module ManagementConsultancy
  class Journey < ::Journey
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      first_step_class = Steps::ChooseLot
      super(first_step_class, slug, params, paths)
    end

    def self.journey_name
      'management-consultancy'
    end

    def start_path
      management_consultancy_path
    end
  end
end
