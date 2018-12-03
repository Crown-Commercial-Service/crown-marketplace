module SupplyTeachers
  class JourneyController < ::JourneyController
    require_framework_permission :supply_teachers

    def journey_class
      Journey
    end
  end
end
