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

    # rubocop:disable Metrics/AbcSize, Style/RescueStandardError
    def call(env)
      request = Rack::Request.new(env)
      Rails.logger.info('rak.session: ')
      Rails.logger.info(env['rack.session'])
      Rails.logger.info('stored_state: ')
      Rails.logger.info(env['rack.session']['omniauth.state'])
      Rails.logger.info('accept_header: ')
      Rails.logger.info(request.has_header?('Accept') ? request.get_header('Accept') : request.get_header('HTTP_ACCEPT'))
      Rails.logger.info('error: ')
      Rails.logger.info(request.params['error'])
      Rails.logger.info('error_reason: ')
      Rails.logger.info(request.params['error_reason'])
      Rails.logger.info('error_description: ')
      Rails.logger.info(request.params['error_description'])
      Rails.logger.info('error_uri: ')
      Rails.logger.info(request.params['error_uri'])
      if request.path == '/auth/dfe/callback' && request.params.empty? && !OmniAuth.config.test_mode
        response = Rack::Response.new
        response.redirect('/auth/dfe')
        response.finish
      else
        @app.call(env)
      end
    rescue => e
      Rails.logger.info('EXCEPTION STARTS')
      Rails.logger.info(e.message)
      Rails.logger.info(e.backtrace.join("\n"))
      Rails.logger.info('EXCEPTION ENDS')
    end
  end
  # rubocop:enable Metrics/AbcSize, Style/RescueStandardError

  Rails.application.config.middleware.insert_before OmniAuth::Strategies::OpenIDConnect, DfeSignIn
end
