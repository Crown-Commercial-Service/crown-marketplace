require 'omniauth/strategies/cognito'

client_id = ENV.fetch('COGNITO_CLIENT_ID')
client_secret = ENV.fetch('COGNITO_CLIENT_SECRET')
cognito_options = {
  client_options: {
    site: ENV.fetch('COGNITO_USER_POOL_SITE')
  },
  callback_path: '/auth/cognito/callback',
  scope: 'email openid',
  region: ENV.fetch('COGNITO_AWS_REGION'),
  user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID')
}

Rails.application.config.middleware.use OmniAuth::Strategies::Cognito, client_id, client_secret, cognito_options

module Cognito
  def self.pool_site
    ENV.fetch('COGNITO_USER_POOL_SITE')
  end

  def self.client_id
    ENV.fetch('COGNITO_CLIENT_ID')
  end

  def self.logout_path(redirect)
    "#{pool_site}/logout?client_id=#{client_id}&logout_uri=#{redirect}"
  end
end
