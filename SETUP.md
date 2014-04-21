# Setting up your workstation

## Prerequisites
* git
* github.com account
* Ruby 2.1.1, Rails 4.0.4
* bundler
* PostgreSQL (preferred, other DBs will do with minor changes)
* a heroku.com account and the [Heroku Toolbelt](https://toolbelt.heroku.com) installed (optional, but you'll have way more fun)

## Code for this workshop
* `git clone git@github.com:timbogit/inventory_service.git`
* `git clone git@github.com:timbogit/tags_service.git`
* `git clone git@github.com:timbogit/cities_service.git`
* `git clone git@github.com:timbogit/deals.git`

## Setting up the apps locally:
* In each of the 3 `..._service` apps:
	* `$ bundle install`
	* `$ bundle exec rake db:create`
	* `$ bundle exec rake db:migrate`
	* `$ bundle exec rake db:fixtures:seed`
	* `$ rails s -p <unique_port_of_your_choice>`
	* NOTE: if you want services to talk to dependent service locally, ask for instructions
* In the front-end `deals` app:
	* `$ bundle install`
	* `$ rails s -p <unique_port_of_your_choice>`


## Heroku setup (optional, but recommended)
* visit [Heroku](https://www.heroku.com/home) and sign up for a free developer account
* we are loosely following the ["Getting Started with Rails 4.x on Heroku"](https://devcenter.heroku.com/articles/getting-started-with-rails4) guide:
	* `$ heroku login`
	* in each of the `..._service` local git repos, do:
		* `$ heroku apps:create <my_unique_heroku_app_name>` 
		* `$ heroku git:remote -a <my_unique_heroku_app_name> -r development`
		* `$ git push development master`
		* `$ heroku run rake db:migrate`
		* `$ heroku run rake db:seed`
			* NOTE: the `cities-service` DB seed exceed the limit for the "Hobby Dev" pg instance; either trim down the seeds file to < 10k entries, or upgrade to "Hobby Basic" (~ $9 / month)
		* `$ heroku  ps:scale web=1`
	* visit your app, via a browser, or maybe via `$ heroku open`
* Other useful `heroku` commands:
	* `heroku logs` : shows your app's rails logs
	* `heroku run rails console` : bring up a rails console on your application server
	* `heroku maintenance:[on|off]` : dis-/enables your app and shows a maintenance page
	* `heroku ps` : lists all your app's dynos, and what they are running
	* `heroku ps:scale web=[0|1]` : dis-/enables your web worker dynos
	* `heroku config:set MY_ENV_VAR=foo --remote development` : sets an environment variable (e.g., RAILS_ENV) on your app's server
	



