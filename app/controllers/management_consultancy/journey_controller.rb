module ManagementConsultancy
  class JourneyController < FrameworkController
    include JourneyControllerActions

    require_permission :management_consultancy

    def journey_class
      Journey
    end
  end
end
