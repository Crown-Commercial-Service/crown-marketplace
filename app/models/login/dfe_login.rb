module Login
  class DfeLogin < Login::BaseLogin
    def self.from_omniauth(hash)
      Rails.logger.info("Login attempt from dfe > OmniAuth hash extra #{hash.dig('extra').inspect}")
      school_id = hash.dig('extra', 'raw_info', 'organisation', 'type', 'id')
      organisation_category = hash.dig('extra', 'raw_info', 'organisation', 'category', 'id')
      new(
        email: hash.dig('info', 'email'),
        extra: {
          'school_id' => school_id,
          'organisation_category' => organisation_category
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
      return true if multi_academy_trust?

      school_type.non_profit?
    rescue NoMethodError
      school_id = @extra['school_id']
      organisation_category = @extra['organisation_category']
      Rails.logger.info(
        "Login failure from dfe > SchoolType not found for school type \
id: #{school_id.inspect}, organisation category id: #{organisation_category.inspect}"
      )
      false
    end

    def multi_academy_trust?
      @extra['organisation_category'].to_s == '010'
    end
  end
end
