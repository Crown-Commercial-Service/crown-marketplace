require 'omniauth/strategies/cognito'

client_id = Marketplace.cognito_client_id
client_secret = Marketplace.cognito_client_secret
cognito_options = {
  client_options: {
    site: Marketplace.cognito_user_pool_site
  },
  callback_path: '/auth/cognito/callback',
  scope: 'email openid',
  region: Marketplace.cognito_aws_region,
  user_pool_id: Marketplace.cognito_user_pool_id
}

Rails.application.config.middleware.use OmniAuth::Strategies::Cognito, client_id, client_secret, cognito_options
