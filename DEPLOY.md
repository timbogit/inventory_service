# Development and Deployment Workflow

## Manage several environments:
* local development machine (running tests and used for developing)
  * all your local development is done here
  * only check out the services you actually need to change
  * service yml's for all dependent services point into the `development` fabric (next)

* remote `development` (or staging) fabric
  * all services run here at a *known good* domain name
  * e.g., `cities-service-development`, `tags-service-development`,
   `inventory-service-development`
  * once development is complete, new (feature) branches get promoted to here
  * data here is 'production like', so that production conditions can be simulated, but probably seed data.
  * after some quality assurance, code will be promoted to the next (`production`) stage
 
* `production` fabric
  * stable production level code
  * data is the actual production data
  * this is the code and service instances that the end customers will see
  
## How is this implemented?  
* every app has (yml) configuration files that declare where their dependent services are located:
  * for the `test`, `development` and `production` envrionments (e.g., the respective sections in `config/tags_service.yml` and `config/cities_service.yml`)
  * the `development` sections point at the well-known development fabric instances of the dependent service, while `production` sections point at production services
  * the `test` sections most likely point at the well-known development fabric instances, or the actual production services
    * this way, tests can retrieve (test) data from such dependencies without having to run them all locally
    * the service responses can be stored in *canned responses* for future runs (e.g. using gems like `vcr`)

## Working with Heroku
* Heroku has good [documentation](https://devcenter.heroku.com/articles/multiple-environments) for working with multiple environments
* Create your development fabric instance of a service via the `heroku command line tool
  * `heroku create --remote development` 
  	
  	...or rename your current `heroku` remote via 
  
  	`git remote rename heroku development`
  	
* Create your production fabric instance of a service

  * `heroku create --remote production`
  
  
* By default, `heroku` apps run in `production` environment mode; to have your `development` fabric instances all easily point at each other, change their `RACK_ENV` and `RAILS_ENV` environment settings to `development`, like so:
  * `heroku config:set RACK_ENV=development RAILS_ENV=development --remote development --app <my_dev_heroku_appname>`
  
* As `heroku` ignores all branches that are *not* `master`, you need to push you local feature branches to the remote master branches
  * I.e., to push a branch called `features` to your `development` fabric instance, you need to do:
  	 
  	 `git push development feature:master`
  	 
* As an example of my current `git` set-up for `inventory_service`:

	````
	$ git remote -v
	development	git@heroku.com:inventory-service-development.git (fetch)
	development	git@heroku.com:inventory-service-development.git (push)
	origin	git@github.com:timbogit/inventory_service.git (fetch)
	origin	git@github.com:timbogit/inventory_service.git (push)
	production	git@heroku.com:inventory-service.git (fetch)
	production	git@heroku.com:inventory-service.git (push)
	````

## Exercise
* Create `production` and `development` instances on `heroku` for all three services, and adapt your `git` remotes respectively.  
* The `inventory_service` depends on `cities_service` and `tags_service`, so the services' config yml files (`tags_service.yml` and `cities_service.yml`) will need to be pointed at your `production` and `development` fabric instances respectively. Keep your `test` yml file entries pointed at your `development` fabric instances.
* Make similar changes to the `cities_service` repository, so that it will point at the dependent `tags_service` in its respective `development` and `production` fabrics
* push these changes (as new git branches?) first to your `development` fabric boxes, and then - after some initial testing - through to the `production` fabric services

	