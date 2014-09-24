source 'https://rubygems.org'

# Core
gem 'rails', '4.0.4'
gem 'mysql2'
gem 'protected_attributes'

# App
gem 'oj'
gem 'typhoeus'
gem 'hashie'

group :test do
  gem "turn"
  gem "mocha", :require => false
end

group :test, :development do
  gem 'minitest-rails'
  gem 'debugger'
end

group :development do
  gem 'foreman'
  gem 'perftools.rb'
  # Docs
  gem 'swagger-docs'
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

ruby "2.1.1"
