module Login
  class CognitoLogin < Login::BaseLogin
    def self.from_omniauth(hash)
      new(email: hash.dig('info', 'email'), extra: nil)
    end

    def auth_provider
      :cognito
    end

    def logout_path(routable)
      ::Cognito.logout_path(routable.gateway_path)
    end

    def permit?(_framework)
      true
    end
  end
end
