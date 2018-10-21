require 'omniauth/strategies/cognito'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    OmniAuth::Strategies::Cognito,
    ENV.fetch('COGNITO_CLIENT_ID'),
    ENV.fetch('COGNITO_CLIENT_SECRET'),
    client_options: {
      site: ENV.fetch('COGNITO_USER_POOL_SITE')
    },
    callback_path: '/auth/cognito/callback',
    scope: 'email openid',
    user_pool_id: ENV.fetch('COGNITO_USER_POOL_ID'),
    aws_region: ENV.fetch('AWS_REGION')
  )
end

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
