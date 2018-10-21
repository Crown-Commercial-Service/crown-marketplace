require 'omniauth/strategies/cognito'

client_id = ENV.fetch('COGNITO_CLIENT_ID')
client_secret = ENV.fetch('COGNITO_CLIENT_SECRET')
cognito_options = {
  client_options: {
    site: ENV.fetch('COGNITO_USER_POOL_SITE')
  },
  callback_path: '/auth/cognito/callback',
  scope: 'email openid'
}

Rails.application.config.middleware.use OmniAuth::Strategies::Cognito, client_id, client_secret, cognito_options
