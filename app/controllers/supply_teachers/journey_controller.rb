module SupplyTeachers
  class JourneyController < ::JourneyController
    require_permission :supply_teachers

    def journey_class
      Journey
    end
  end
end
