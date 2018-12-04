module SupplyTeachers
  class JourneyController < FrameworkController
    include JourneyControllerActions

    require_permission :supply_teachers

    def journey_class
      Journey
    end
  end
end
