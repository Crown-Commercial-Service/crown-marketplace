require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require "action_cable/engine"
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Marketplace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.action_controller.include_all_helpers = false
  end

  def self.feedback_email_address
    'info@crowncommercial.gov.uk'
  end

  def self.support_email_address
    'info@crowncommercial.gov.uk'
  end

  def self.support_telephone_number
    '0345 410 2222'
  end

  def self.ccs_homepage_url
    'https://www.crowncommercial.gov.uk/'
  end

  def self.http_basic_auth_name
    @http_basic_auth_name ||= ENV.fetch('HTTP_BASIC_AUTH_NAME')
  end

  def self.http_basic_auth_password
    @http_basic_auth_password ||= ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
  end

  def self.cognito_user_pool_site
    @cognito_user_pool_site ||= ENV.fetch('COGNITO_USER_POOL_SITE')
  end

  def self.cognito_user_pool_id
    @cognito_user_pool_id ||= ENV.fetch('COGNITO_USER_POOL_ID')
  end

  def self.cognito_client_id
    @cognito_client_id ||= ENV.fetch('COGNITO_CLIENT_ID')
  end

  def self.cognito_client_secret
    @cognito_client_secret ||= ENV.fetch('COGNITO_CLIENT_SECRET')
  end

  def self.cognito_aws_region
    @cognito_aws_region ||= ENV.fetch('COGNITO_AWS_REGION')
  end

  def self.google_analytics_tracking_id
    @google_analytics_tracking_id ||= ENV['GA_TRACKING_ID']
  end

  def self.google_geocoding_api_key
    @google_geocoding_api_key ||= ENV.fetch('GOOGLE_GEOCODING_API_KEY')
  end
end
