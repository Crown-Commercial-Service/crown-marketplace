class CurrentOrganisation
  class << self
    def use_gca_branding?
      Time.zone.now.utc >= Time.zone.parse(ENV.fetch('GCA_BRANDING_LIVE_AT', nil)).utc
    rescue StandardError
      false
    end

    def current_organisation_name
      use_gca_branding? ? 'Government Commercial Agency' : 'Crown Commercial Service'
    end

    def current_organisation_name_abbr
      use_gca_branding? ? 'GCA' : 'CCS'
    end

    def current_organisation_domain
      use_gca_branding? ? 'gca' : 'crowncommercial'
    end
  end
end
