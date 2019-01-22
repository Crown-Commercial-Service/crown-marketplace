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

    def logout_url(routable)
      routable.supply_teachers_gateway_url
    end

    def permit?(framework)
      result = framework == :supply_teachers && non_profit? && whitelisted?
      log_attempt(result)
      result
    end

    private

    def school_type
      SupplyTeachers::SchoolType.find_by(id: @extra['school_id'].to_s)
    end

    def whitelisted?
      return true unless Marketplace.dfe_signin_whitelist_enabled?

      Marketplace.dfe_signin_whitelisted_email_addresses.include?(email)
    end

    def non_profit?
      school_type.non_profit?
    rescue NoMethodError
      school_id = @extra['school_id']
      Rails.logger.info("Login failure from dfe > SchoolType not found for school type id: #{school_id.inspect}")
      false
    end
  end
end
