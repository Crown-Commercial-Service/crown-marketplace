module Apprenticeships
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      byebug
      first_step_class = FindApprentices
      super(first_step_class, slug, params, paths)
    end

    def self.journey_name
      'apprenticeships'
    end

    def start_path
      legal_services_path
    end
  end
end
