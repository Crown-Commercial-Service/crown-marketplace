module FacilitiesManagement
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(framework, slug, params)
      paths = JourneyPaths.new(self.class.journey_name)
      first_step_class = FIRST_STEP_CLASS[framework]
      super(first_step_class, framework, slug, params, paths)
    end

    def self.journey_name
      'facilities-management'
    end

    def start_path
      facilities_management_index_path(framework: @framework)
    end

    def next_step_path
      case next_slug
      when 'procurement'
        "/facilities-management/#{@framework}/procurements/new?journey=facilities-management&#{params.to_query}"
      else
        super
      end
    end

    FIRST_STEP_CLASS = {
      'RM3830' => FacilitiesManagement::RM3830::Journey::ChooseServices,
      'RM6232' => FacilitiesManagement::RM6232::Journey::ChooseServices,
      'RM6378' => FacilitiesManagement::RM6378::Journey::ChooseServices
    }.freeze
  end
end
