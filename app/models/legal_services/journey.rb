module LegalServices
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      super(self.class.first_step_class, slug, params, paths)
    end

    def self.journey_name
      'legal-services'
    end

    def self.first_step_class
      ChooseOrganisationType
    end

    def start_path
      legal_services_path
    end
  end
end
