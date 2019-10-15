if Marketplace.dfe_signin_enabled?
  options = {
    name: :dfe,
    discovery: true,
    response_type: :code,
    scope: %i[openid email organisation],
    client_options: {
      port: Marketplace.dfe_signin_uri.port,
      scheme: Marketplace.dfe_signin_uri.scheme,
      host: Marketplace.dfe_signin_uri.host,
      identifier: Marketplace.dfe_signin_client_id,
      secret: Marketplace.dfe_signin_client_secret,
      redirect_uri: Marketplace.dfe_signin_redirect_uri
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
