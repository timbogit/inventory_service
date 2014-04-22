# Documenting and Generating your APIs

APIs will only be used when there is documentation on how to use them. We recommend you think about how to structure and document your APIs from day one.

## Standards and Consistency
"The Good Thing About Standards: there are so many of them" (TM)

Even if you say your API is RESTful, it doesn't really say much in detail. Spend the time to dnegotiate guidelines internal to your organization, spend some time thinking about all the various options and degrees of freedom, and then, most importantly, *stick to them*. The principal of least surprise will pay off for your clients, and for yourself.

* What HTTP Status (success and error) codes will you use for which situations
	* 204 or 200 for POSTs/PUTs?
	* consistency around the 4xx code range
* Will there be additional error messaging in the body?
* Where does authentication go?
	* header, url, ...
* Consistency in resource hierarchy
	* Truly "RESTful", or are there some "RPC" like endpoints (/inventory_items/near_city) 
* True 'hypermedia' with self-discover, or simply show IDs?
	* `{'id': 123'}` vs. `{'uri': 'http://some.host.com/api/resource/123'}`
* ...

## Specifying your Endpoints
"What do you mean, specifying the endpoints ... can't you read the routes file?!"

Just not good enough, sorry! You just spent all this time going over some standards and consistency, now spend a little more to define your API in a "machine digestible", declarative format. 

This specification should preferably be published at a (well-known) endpoint in your application, so that your clients can auto-discover your APIs ... and maybe even auto-generate client code. 


## Using an IDL

We have found during our careers that IDLs are a very convenient thing, and that the benefits by far outweigh the effort. And no, you don't need to learn JEE, WS-* or XML for all this.

JSON-RPC, ProtoBuf, Thrift (all of which have Ruby bindings), and the like, all follow the same principle. You specify your API in some schema, and then client libraries / gems, and often even service-side stubs are generated for you ... either via a separate 'build step' (rake tasks, e.g.) ahead of time, or even 'on the fly' when clients are consuming the IDL specification of your published endpoints. Best of all, most of these tools work cross-language (Java shop, anyone?), and oƒten have support for auto-generating human-readable docs. 


## What we use: Swagger

### Specification via JSON Schema
"[Swagger™](https://github.com/wordnik/swagger-spec)  is a specification and complete framework implementation for describing, producing, consuming, and visualizing RESTful web services."

In essence, you use JSON to specify your endpoints, according to a well-defined schema. A suite of surrounding tools help with auto-generating the JSON based on annotations or DSLs, auto-generating client and service stub code (across a growing set of languages).
The project is open-source, maintained by [Wordnik](http://developer.wordnik.com/docs).

See [here](http://inventory-service-development.herokuapp.com/api_docs/v1/api-docs.json) and [here](http://inventory-service-development.herokuapp.com/api_docs/v1/inventory_items.json) for the `inventory-service`'s JSON specs.

### Ruby Tools
Here are some of the Ruby-specific projects surrounding swagger.

##### [swagger-docs](https://github.com/richhollis/swagger-docs) / [swagger-yard](https://github.com/synctv/swagger_yard)
Two (competing?) gems that allow for specifying your APIs in a Ruby DSL, and then generating the JSON specification via a separate rake task. See some [sample swagger-docs DSL code that describes the inventory-service](https://github.com/timbogit/inventory_service/tree/master/app/controllers/inventory_items_controller.rb#109-151).

Unfortunately, neither of these two gems is entirely mature, but hey: it's Open-Source, so go and contribute!

##### [swagger-codegen](https://github.com/wordnik/swagger-codegen) / [grape-swagger](https://github.com/tim-vandecasteele/grape-swagger)
Swagger-codegen is the general project to generate client code by parsing your Swagger JSON specs. Ruby support exists, albeit less 'stable' than for scala.
Swagger-grape is a gem to add swagger compliant documentation to a grape API. 

### Killer feature: Service Explorer
A swagger subproject called [swagger-ui](https://github.com/wordnik/swagger-ui) is essentially a single HTML page plus some spiffy CSS and JavaScript to consume your JSON API specs to generate a very useful 'service explorer' UI. This UI lists all your endpoints, and gives you the option to fire single requests for each of them to your server.

You can see it in action in each of the root pages for our sample services:

* [`cities-service` swagger UI explorer](http://cities-service-development.herokuapp.com/), 
* [`tags-service` swagger UI explorer](http://tags-service-development.herokuapp.com/),
* [`inventory-service` swagger UI explorer](http://inventory-service-development.herokuapp.com/) 

**NOTE**: To make these links work with your own heroku apps, you will need to adapt the URIs in your swagger UI index page, as well as inside the API JSON specs. See Tim for help :-) 


