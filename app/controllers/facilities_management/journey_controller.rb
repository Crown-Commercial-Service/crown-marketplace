module FacilitiesManagement
  class JourneyController < FrameworkController
    include JourneyControllerActions

    require_permission :facilities_management

    def journey_class
      Journey
    end
  end
end
