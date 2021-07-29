module FacilitiesManagement
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(framework, slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      first_step_class = "FacilitiesManagement::#{framework}::Journey::ChooseServices".constantize
      super(first_step_class, framework, slug, params, paths)
    end

    def self.journey_name
      'facilities-management'
    end

    def start_path
      "/facilities-management/#{@framework}"
    end

    def next_step_path
      case next_slug
      when 'procurement'
        "/facilities-management/#{@framework}/procurements/new?journey=facilities-management&#{params.to_query}"
      else
        super
      end
    end
  end
end
