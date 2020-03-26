module LegalServices
  class JourneyController < LegalServices::FrameworkController
    include JourneyControllerActions

    def journey_class
      Journey
    end
  end
end
