# Optimiziting for client performance

## Restricting the response size
Benchmarking our our services, we noticed that the lion's share of slow APIs were growing linearly slower with the size of the (JSON) response. 

Once there is enough data, the share of connection setup / teardown times and even DB queries are dwarfed by time spent in:

* result serialization into JSON
* shipping large JSON payloads over the wire
* de-serializing the JSON client-side

Here are some tips of how we went about addressing these issues.


### Result paging

* Provide the client with an option to request a limited amount of results whenever a list of objects is returned (e.g., `#index` or `#search` like actions)
* A very simple and yet effective way of providing such "poor man's paging" s to accept `limit` and `offset` parameters for such list endpoints
* To improve performance, experiment with optimal default and maximum values for such a `limit` parameter
	* finding the 'sweat spot' that is acceptable for both the clients and the service depends very much on your data and use cases, and you will find yourself iterating a coule of times on the best number 

### Content Representations

* Not **every** client needs **all** the information the service can know about an 'entity'
* A good way to provide flexibility is to honor requests for different representations of a 'thing'
	* some clients might just need two or three fields of potentially 10s/100s of existign fields
	* try and make it easy for clients to define and iterate over) the best representation for their use case
* Good candidates for information that might be worth removing is any information that might come from a secondary service (e.g., the tags or the city name for an inventory item).
	* some clients might be able to make secondary requests to the authoritative service for such information (e.g., to `cities-service` and `tags-service`)
	* other clients might want to have this aggregated information be returned by a service, but only when requesting a *single* object (e.g., one inventory item)
	

## Make the service work less

Retrieving information from the DB and serializing it take valuable time in the API request/response cycle. Here are some ways to avoid incurring this time.

### HTTP Conditional GET
Using `ETag`, `Last-Modified` and `Cache-Control` response headers is standardized, yet flexible ... and still very often unused in API services.  

Rails has great support for honoring and setting the respective HTTP request / response headers to allow clients to specify what that of the service objects they know, and the service to declare when and how this information will become stale.

While it is not easy to find Ruby HTTP client libraries that automatically honor / send these headers, browsers will certainly honor them out of the box, and so will reverse proxies (see next section)


### Using a Reverse Proxy
For our most-trafficed internal API services, LivingSocial relies heavily on [Varnish](https://www.varnish-cache.org/), a reverse proxy that has excellent performance and scaling characteristics:

* some endpoints are sped up by a factor of 50x
* varnish is flexible enough to function as a 'hold the fort' cache
	* if the fronted service is down, it can return the last good (= 2XX Status Code) response
* It can be administered to cache based on a full URI, including or excluding headers
	* tip 1:  try making all query parameters sorted, so that any reverse proxy can a higher cache hit rate
	* tip 2: make all parameters (like authentication) that do *not* affect the JSON responses be sent in request headers, and make varnish igonre these headers for the cache key
	
##Exercises
1. Add a 'small' and a 'full' inventory item representation
	a. 'full' is the currently existing representation which makes dependent calls out to `cities-service` and `tags-service` for all city and tagging information on inventory items.
	b. small represented inventory items just have the Hyperlinked URI for their `city` and their `tags` inside `cities-service` and `tags-service`
	c. make the representation be selectable via a `representation` query paramter, which will be honored by all endpoints that return inventory items (`#show`, `#index`, `#in_city`, `#near_city`)


2. Add "limit and offset" based paging of results
	a. allow for paging through API-returned inventory items by letting the client request a smaller number of results (via a `limit` query parameter), and starting at a particular offset (via an additional `offset` parameter)
	b. make these paging paraeters be honored by all endpoints that return lists of inventory items (`#index`, `#in_city`, `#near_city`)


3. Make sure to look at the various places in the `application_controller` and the `inventory_items_controller` that implemented service-side HTTP Conditional GET logic
	a. Come up with a `curl` request that makes the `inventory_items#show` endpoint return a 304 response, based on a `If-Modified-Since` request header
	b. Come up a `curl` request that makes the `inventory_items#show` endpoint return a 304 response, based on a `If-None-Match` request header
