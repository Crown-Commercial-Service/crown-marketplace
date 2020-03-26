module ManagementConsultancy
  class JourneyController < ManagementConsultancy::FrameworkController
    include JourneyControllerActions

    def journey_class
      Journey
    end
  end
end
