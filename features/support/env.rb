require 'cucumber/rails'
require 'webmock/cucumber'
require 'cucumber/rspec/doubles'
require 'sidekiq/testing/inline'
require 'active_support/core_ext/string/inflections'
require 'factory_bot_rails'
require 'webdrivers'
require 'rails'
require 'site_prism'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'capybara-screenshot/cucumber'

require_relative '../support/capybara_driver.helper'
require_relative '../support/pages_helper'
require_relative '../support/login_helper'

World(FactoryBot::Syntax::Methods)
World(Cognito)
World(Base)
World(Pages)

module Cucumber
  module RunningTestCase
    class TestCase < SimpleDelegator
      def feature
        string = File.read(location.file)
        document = ::Gherkin::Parser.new.parse(string)
        document[:feature]
      end
    end
  end
end

allowed_sites = [/__identify__/,
                 /127.0.0.1.*(session|shutdown)/,
                 /chromedriver.storage.googleapis.com/]

Webdrivers::Chromedriver.update

WebMock.disable_net_connect!(allow: allowed_sites)

DatabaseCleaner.strategy = nil

# By default, cucumber-rails will auto mix-in the helpers from Rack::Test into your default Cucumber World instance.
# You can prevent this behaviour by setting ENV['CR_REMOVE_RACK_TEST_HELPERS'] = 'true'
ENV['CR_REMOVE_RACK_TEST_HELPERS'] = 'true'

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { except: [:widget_data_providers] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('not @no-txn', 'not @selenium', 'not @culerity', 'not @celerity', 'not @javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :transaction
load Rails.root.join('db', 'seeds.rb')

# Before do |_scenario|
#   Populators::TransactionTypePopulator.call
#   # Delete previous screenshots from filesystem that were generated during previous feature runs
#   FileUtils.rm_rf("#{Rails.root}/tmp/capybara/**.*")
# end
