module Apprenticeships
  class JourneyController < FrameworkController
    include JourneyControllerActions

    def journey_class
      Journey
    end
  end
end
