module FacilitiesManagement
  class JourneyController < ::JourneyController
    require_framework_permission :facilities_management

    def journey_class
      Journey
    end
  end
end
