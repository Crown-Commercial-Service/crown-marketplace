source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'geocoder'
gem 'activerecord-postgis-adapter'
gem 'uk_postcode'
gem 'axlsx', github: 'randym/axlsx', branch: 'release-3.0.0'
gem 'rubyzip', '>= 1.2.1'
gem 'caxlsx'
gem 'axlsx_rails', '>= 0.6.0'
gem 'phonejack'
gem 'holidays'
gem 'virtus'
gem 'jquery-rails', '~> 4.3.5'

# for cognito authentication
gem 'omniauth', '~> 1.9.0'
gem 'omniauth-oauth2', '~> 1.6.0'
# updating to the latest gem version causes an error when response_type is :code. A fix is coming but has not been merged in yet, so will be using this forked repo until then
gem 'omniauth_openid_connect', git: 'https://github.com/iceraluk/omniauth_openid_connect.git'
gem 'json-jwt'

# for authentication
gem 'devise', '~> 4.7.1'

gem 'aws-sdk-cognitoidentityprovider', '~> 1.23.0'

# for pagination
gem 'kaminari', '~> 1.1.1'

# for pretty urls
gem 'friendly_id', '~> 5.2.4'

# aws s3 bucket access for postcode data
gem 'aws-sdk-s3', '~> 1'

# for file uploads
gem 'carrierwave', '~> 1.0'

# handles spreadsheets
gem 'roo', '~> 2.8.2'

# manipulating JSON for anonymisation
gem 'jsonpath', '~> 0.5.8'

# robust file download from URL using open-uri
gem 'down'

# state machine
gem 'aasm', '~> 5.0'

# for running background jobs
gem 'sidekiq', '~> 5.2.7'
gem 'sinatra', '~> 2.0.5', require: false
gem 'slim', '~> 4.0.1'

# for rspec and ST data generation script
gem 'capybara'

gem 'faker'

# for authorization
gem 'cancan', '~> 1.6.10'

gem 'role_model', '~> 0.8.2'

# for S3 storage of files
gem 'carrierwave-aws', '~> 1.3.0'

gem 'sprockets'
gem 'sprockets-bumble_d', '>= 2.1.0'

# for date layout and validation
gem 'gov_uk_date_fields', '>= 4.1.0'
gem 'date_validator'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '>= 2.7.2'
  gem 'factory_bot_rails', '>= 5.0.2'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rails-controller-testing', '>= 1.0.4'
  gem 'rspec-rails', '>= 3.8.2'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rubyXL', '>= 3.4.3'
  gem 'i18n-tasks', '>= 0.9.29'
  gem 'poltergeist'
  gem 'wdm', '>= 0.1.0', platforms: %i[x64_mingw]
  gem 'tzinfo-data', platforms: %i[x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'webmock'
  gem 'simplecov', require: false
  gem 'selenium-webdriver', '>= 3.142.3'
end
