module FacilitiesManagement
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      first_step_class = ChooseServices
      super(first_step_class, slug, params, paths)
    end

    def self.journey_name
      'facilities-management'
    end

    def start_path
      facilities_management_path
    end

    def next_step_path
      case next_slug
      when 'procurement'
        new_facilities_management_procurement_path(journey: self.class.journey_name, params: params)
      else
        super
      end
    end
  end
end
