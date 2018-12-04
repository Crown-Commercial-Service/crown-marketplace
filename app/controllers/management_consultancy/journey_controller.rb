module ManagementConsultancy
  class JourneyController < ::ApplicationController
    include JourneyControllerActions

    require_permission :management_consultancy

    def journey_class
      Journey
    end
  end
end
