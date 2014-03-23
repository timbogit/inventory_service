source 'https://rubygems.org'

# Core
gem 'rails', '4.0.4'
gem 'pg'
gem 'protected_attributes'

# App
gem 'oj'

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
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

ruby "2.1.1"
