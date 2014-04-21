# Caching Service Responses Client-Side


Making service calls can be expensive for your application. But fortunately, the service clients can often tolerate data that is slightly stale. 

A good way to exploit this fact is to cache service responses client-side, i.e., inside the front-end applications, or other services depending on your service. The fastest service calls are the ones you never need to make. 

Here are some things we learned when considering these points:

### Build caching into your client gem
* Often, you will develop your own Ruby client gems for the services you build.
	* we do it at LivingSocial, on top of a general low-level gem that takes care of all general HTTP communication and JSON (de)serialization
* Offer the option to inject a cache into your client gem
	* use the injected cache to store all service call responses
	* spend some time to think about your cach keys (e.g., include the gem and API version, full service URL)
* require as little as feasibly possible about the cache object that is injected
	* we usually just require it have a `#fetch` method that takes a cache key and a block to execute on cache miss
	
### Have the clients decide if / how to cache
* Some clients might not want to cache at all, so they should be able to just disable caching in your gem
* It is the client applications responsibility to set cache expiration policies, cache size, and caching back-end
	* Rails client apps could simply use `Rails.cache`, some others a `Dalli::Client` instance, a `ActiveSupport::Cache::MemoryStore`, or even something 'hand-rolled' by your clients.

##Exercise
This will make you build a 'client-gem like' code (albeit inside of the `inventory_service` application), which will allow for caching; you will also set up your `inventory_service` code to administer a cache for this code.

* Abstract commong functionality of the `Remotetag` and `RemoteCity` classes into a common superclass (e.g., named `RemoteModel`)
	* Add an accessor for `RemoteModel.cache`, so the application code can choose the cache to use
	* implement a `RemoteModel.with_possible_cache(cache_key, &blk)`, and wrap all calls to `cities_service` and `tags_service` inside it.
	* make sue the `cache_key` passed take the full service call URL and the API version into account
* Add administration of the cache inside of the `tags_service.rb` and `cities_service.rb` initalizers in `inventory_service`. You can chose whichever cache store you like. (We chose `ActiveSupport::Cache::MemoryStore` for simplicity)
