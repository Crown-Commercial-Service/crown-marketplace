module Login
  class DfeLogin < Login::BaseLogin
    def self.from_omniauth(hash)
      new(
        email: hash.dig('info', 'email'),
        extra: {
          'school_id' => hash.dig('extra', 'raw_info', 'organisation', 'type', 'id')
        }
      )
    end

    def auth_provider
      :dfe
    end

    def logout_path(routable)
      routable.supply_teachers_gateway_path
    end

    def permit?(framework)
      framework == :supply_teachers && non_profit? && whitelisted?
    end

    private

    def school_type
      SupplyTeachers::SchoolType.find_by(id: @extra['school_id'])
    end

    def whitelisted?
      Marketplace.dfe_signin_whitelisted_email_addresses.include?(email)
    end

    delegate :non_profit?, to: :school_type, allow_nil: true
  end
end
