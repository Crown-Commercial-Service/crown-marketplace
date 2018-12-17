module Login
  class CognitoLogin < Login::BaseLogin
    PERMITTED_FRAMEWORKS = %i[
      facilities_management
      management_consultancy
    ].freeze

    def self.from_omniauth(hash)
      new(email: hash.dig('info', 'email'), extra: nil)
    end

    def auth_provider
      :cognito
    end

    def logout_url(routable)
      ::Cognito.logout_url(routable.gateway_url)
    end

    def permit?(framework)
      PERMITTED_FRAMEWORKS.include?(framework)
    end
  end
end
