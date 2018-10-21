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
