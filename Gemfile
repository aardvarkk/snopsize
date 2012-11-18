source 'https://rubygems.org'

gem 'rails', '3.2.9'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier'

  # jQuery DataTables gem for Rails, includes all JS and CSS for dataTables widget
  gem 'jquery-datatables-rails'

  # jQuery UI library, includes JS AND CSS
  gem 'jquery-ui-rails'
end

gem 'will_paginate'

# note that while this includes jquery-ui library, it doesn't include the CSS files, so
# built in dialogs and other widgets aren't rendered properly.
gem 'jquery-rails'

#To use devise authentication
gem 'devise'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'

# For fulltext searching
gem 'sunspot_rails'
gem 'sunspot_solr'

# For URI parsing
gem 'addressable'
gem 'public_suffix'

# For generating diagrams
gem 'railroady'

# Production stuff
group :production do
	
  # Use MySQL database in the production environment
  gem 'mysql2'

  # Use Passenger as the app server
  gem 'passenger'
	
end

# This is used to help install RVM and stuff on the server
gem 'rvm-capistrano'

# Testing stuff
group :test do
  gem 'database_cleaner'
  # Use Capybara for testing
  gem 'capybara'
  gem 'capybara-email'
end