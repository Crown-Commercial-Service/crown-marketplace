module SupplyTeachers
  class JourneyController < SupplyTeachers::FrameworkController
    include JourneyControllerActions

    def journey_class
      Journey
    end
  end
end
