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

    def permit?(framework)
      permitted_frameworks.include?(framework)
    end

    private

    def permitted_frameworks
      if Marketplace.supply_teachers_cognito_enabled?
        %i[facilities_management management_consultancy supply_teachers]
      else
        %i[facilities_management management_consultancy]
      end
    end
  end
end
