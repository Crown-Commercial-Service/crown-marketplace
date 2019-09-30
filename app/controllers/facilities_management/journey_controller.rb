module FacilitiesManagement
  class JourneyController < FrameworkController
    include JourneyControllerActions

    def journey_class
      Journey
    end
  end
end
