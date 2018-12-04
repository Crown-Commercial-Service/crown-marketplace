module SupplyTeachers
  class JourneyController < ::ApplicationController
    include JourneyControllerActions

    require_permission :supply_teachers

    def journey_class
      Journey
    end
  end
end
