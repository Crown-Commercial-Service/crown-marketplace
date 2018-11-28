module FacilitiesManagement
  class JourneyController < ::JourneyController
    before_action { require_framework_permission :facilities_management }

    def journey_class
      Journey
    end
  end
end
