module Login
  class DfeLogin < Login::BaseLogin
    def self.from_omniauth(hash)
      Rails.logger.info("Login attempt from dfe > OmniAuth hash extra #{hash.dig('extra').inspect}")
      school_type_id = hash.dig('extra', 'raw_info', 'organisation', 'type', 'id')
      organisation_category = hash.dig('extra', 'raw_info', 'organisation', 'category', 'id')
      new(
        email: hash.dig('info', 'email'),
        extra: {
          'school_type_id' => school_type_id,
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
      SupplyTeachers::SchoolType.find_by(id: @extra['school_type_id'].to_s)
    end

    def organisation_category
      SupplyTeachers::OrganisationCategory.find_by(id: @extra['organisation_category'].to_s)
    end

    def whitelisted?
      return true unless Marketplace.dfe_signin_whitelist_enabled?

      Marketplace.dfe_signin_whitelisted_email_addresses.include?(email)
    end

    def non_profit?
      school_type.non_profit?
    rescue NoMethodError
      organisation_category.non_profit?
    end
  end
end
