module Login
  class CognitoLogin < Login::BaseLogin
    def self.from_omniauth(hash)
      new(email: hash.dig('info', 'email'), extra: nil)
    end

    def auth_provider
      :cognito
    end

    def logout_url(routable)
      ::Cognito.logout_url(routable.gateway_url)
    end

    def permit?(_framework)
      true
    end
  end
end
