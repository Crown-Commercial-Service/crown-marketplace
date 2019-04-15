source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
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
gem 'phonejack'
gem 'holidays'
gem 'virtus'
gem 'jquery-rails'

# for cognito authentication
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth_openid_connect'
gem 'json-jwt'

# for pagination
gem 'kaminari', '~> 1.1.1'

# for pretty urls
gem 'friendly_id', '~> 5.2.4'

# aws s3 bucket access for postcode data
gem 'aws-sdk-s3', '~> 1'

# for file uploads
gem 'carrierwave', '~> 1.0'

# handles spreadsheets
gem "roo", "~> 2.8.0"

# manipulating JSON for anonymisation
gem 'jsonpath', '~> 0.5.8'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rubyXL'
  gem 'i18n-tasks'
  gem 'poltergeist'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'webmock'
  gem 'simplecov', require: false
end
