module FacilitiesManagement
  class JourneyController < FacilitiesManagement::FrameworkController
    include JourneyControllerActions

    rescue_from ActionView::MissingTemplate do
      raise ActionController::RoutingError, 'Not Found'
    end

    def journey_class
      Journey
    end
  end
end
