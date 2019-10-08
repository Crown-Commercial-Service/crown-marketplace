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
      Rails.logger.info('rak.session: ' + env['rack.session'].try(:to_s))
      Rails.logger.info('stored_state: ' + env['rack.session']['omniauth.state'].try(:to_s))
      Rails.logger.info('accept_header: ' + request.has_header?('Accept') ? request.get_header('Accept').try(:to_s) : request.get_header('HTTP_ACCEPT').try(:to_s))
      Rails.logger.info('error: ' + request.params['error'].try(:to_s))
      Rails.logger.info('error_reason: ' + request.params['error_reason'].try(:to_s))
      Rails.logger.info('error_description: ' + request.params['error_description'].try(:to_s))
      Rails.logger.info('error_uri: ' + request.params['error_uri'].try(:to_s))
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
