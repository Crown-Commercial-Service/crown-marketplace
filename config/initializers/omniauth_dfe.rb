DFE_SIGNIN_ENABLED = ENV['DFE_SIGNIN_URL'].present?

if DFE_SIGNIN_ENABLED
  DFE_SIGNIN_URL = URI.parse(ENV.fetch('DFE_SIGNIN_URL'))

  options = {
    name: :dfe,
    discovery: true,
    response_type: :code,
    scope: %i[openid email],
    client_options: {
      port: DFE_SIGNIN_URL.port,
      scheme: DFE_SIGNIN_URL.scheme,
      host: DFE_SIGNIN_URL.host,
      identifier: ENV.fetch('DFE_SIGNIN_CLIENT_ID'),
      secret: ENV.fetch('DFE_SIGNIN_CLIENT_SECRET'),
      redirect_uri: ENV.fetch('DFE_SIGNIN_REDIRECT_URI')
    }
  }
  Rails.application.config.middleware.use OmniAuth::Strategies::OpenIDConnect, options
end
