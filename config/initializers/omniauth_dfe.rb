DFE_SIGNIN_ENABLED = ENV['DFE_SIGNIN_URL'].present?

if DFE_SIGNIN_ENABLED
  DFE_SIGNIN_URL = URI.parse(ENV.fetch('DFE_SIGNIN_URL'))
  DFE_SIGNIN_WHITELISTED_EMAIL_ADDRESSES =
    ENV.fetch('DFE_SIGNIN_WHITELISTED_EMAIL_ADDRESSES', '').split(',')

  options = {
    name: :dfe,
    discovery: true,
    response_type: :code,
    scope: %i[openid email organisation],
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

  class DfeSignIn
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path == '/auth/dfe/callback' && request.params.empty? && !OmniAuth.config.test_mode
        response = Rack::Response.new
        response.redirect('/auth/dfe')
        response.finish
      else
        @app.call(env)
      end
    end
  end

  Rails.application.config.middleware.insert_before OmniAuth::Strategies::OpenIDConnect, DfeSignIn
end
