module ManagementConsultancy
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      first_step_class = ChooseHelpNeeded
      super(first_step_class, slug, params, paths)
    end

    def self.journey_name
      'management-consultancy'
    end

    def start_path
      management_consultancy_path
    end

    def next_step_path
      case next_slug
      when 'suppliers'
        management_consultancy_suppliers_path(journey: self.class.journey_name, params: params)
      else
        super
      end
    end
  end
end
