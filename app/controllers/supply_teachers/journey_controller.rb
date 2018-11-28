module SupplyTeachers
  class JourneyController < ::JourneyController
    before_action { require_framework_permission :supply_teachers }

    def journey_class
      Journey
    end
  end
end
