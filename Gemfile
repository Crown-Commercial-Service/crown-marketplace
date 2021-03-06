source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.7'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3', '>= 4.3.8'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.1', '>= 5.1.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9', '>= 2.9.1'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'geocoder', '>= 1.6.1'
gem 'activerecord-postgis-adapter', '>= 5.2.2'
gem 'uk_postcode'
gem 'rubyzip', '>= 1.2.1'
gem 'caxlsx', '>= 3.1.0'
gem 'caxlsx_rails', '>= 0.6.2'
gem 'phonejack'
gem 'holidays'
gem 'virtus'
gem 'jquery-rails', '~> 4.4.0'

gem 'rollbar', '~> 2.24.0'

# for dfe sign in
gem 'omniauth', '~> 2.0.0'
gem 'omniauth-oauth2', '~> 1.7.1'

gem 'json-jwt', '>= 1.11.0'

# for authentication
gem 'devise', '~> 4.7.3'

# for timing out when session expires
gem 'auto-session-timeout', '~> 0.9.7'

# for cognito
gem 'aws-sdk-cognitoidentityprovider', '~> 1.23.0'

# for pagination
gem 'kaminari', '~> 1.2.1'

# for pretty urls
gem 'friendly_id', '~> 5.2.5'

# aws s3 bucket access for postcode data
gem 'aws-sdk-s3', '~> 1'

# for file uploads
gem 'carrierwave', '~> 1.3'

# handles spreadsheets
gem 'roo', '~> 2.8.3'

# manipulating JSON for anonymisation
gem 'jsonpath', '~> 0.5.8'

# robust file download from URL using open-uri
gem 'down', '>= 5.2.0'

# state machine
gem 'aasm', '~> 5.0'
gem 'after_commit_everywhere', '~> 1.0'

# for running background jobs
gem 'sidekiq', '~> 6.0.7'
gem 'sinatra', '~> 2.0.8', '>= 2.0.8.1', require: false
gem 'slim', '~> 4.0.1'

# for rspec and ST data generation script
gem 'capybara', '>= 3.35.3'
gem 'show_me_the_cookies', '>= 5.0.1'

gem 'faker', '~> 2.10.2'

# for authorization
gem 'cancan', '~> 1.6.10'

gem 'role_model', '~> 0.8.2'

# for S3 storage of files
gem 'carrierwave-aws', '~> 1.3.0'

gem 'sprockets', '>= 3.7.2'
gem 'sprockets-bumble_d', '>= 2.2.0'

gem 'smarter_csv'

# for date layout and validation
gem 'gov_uk_date_fields', '>= 4.1.0'
gem 'date_validator', '>= 0.9.0'

# for clamav
gem 'ratonvirus', '>= 0.1.1'
gem 'ratonvirus-clamby', '>= 0.1.0'
# for active storage validation
gem 'active_storage_validations', '>= 0.9.2'
# gem for  bulk inserts
gem 'activerecord-import', '~> 0.15.0'
# gov notify
gem 'notifications-ruby-client'
# DOCX generation
gem 'caracal-rails', '>= 1.0.2'

# duplicating procurements
gem 'amoeba', '>= 3.1.0'

# For validating emails
gem 'email_validator', require: 'email_validator/strict'

# for cloud storage of assets
gem 'asset_sync'
gem 'fog-aws', '>= 3.10.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '>= 2.7.6'
  gem 'factory_bot_rails', '>= 6.1.0'
  gem 'launchy', '>= 2.5.0'
  gem 'pry-rails'
  gem 'rails-controller-testing', '>= 1.0.5'
  gem 'rspec-rails', '>= 5.0.1'
  gem 'shoulda-matchers', '>= 4.2.0'
  gem 'rubocop', '>= 1.11.0'
  gem 'rubocop-rspec', '>= 2.2.0'
  gem 'rubocop-rails', '>= 2.9.1', require: false
  gem 'rubyXL', '>= 3.4.17'
  gem 'i18n-tasks', '>= 0.9.34'
  gem 'poltergeist', '>= 1.18.1'
  gem 'wdm', '>= 0.1.0', platforms: %i[x64_mingw]
  gem 'tzinfo-data', platforms: %i[x64_mingw]
  gem 'bullet', require: true
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :test do
  gem 'webmock', '>= 3.12.1'
  gem 'simplecov', '>= 0.16.1', require: false
  gem 'selenium-webdriver', '>= 3.142.3'
  gem 'cucumber-rails', '>= 2.3.0', require: false
  gem 'database_cleaner', '>= 2.0.1'
  gem 'site_prism', '>= 3.7.1'
  gem 'axe-core-capybara', '>= 4.1.0'
  gem 'axe-core-cucumber', '>= 4.1.0'
end
