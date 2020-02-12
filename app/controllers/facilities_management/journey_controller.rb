module FacilitiesManagement
  class JourneyController < FacilitiesManagement::FrameworkController
    include JourneyControllerActions

    def journey_class
      Journey
    end
  end
end
