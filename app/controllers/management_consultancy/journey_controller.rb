module ManagementConsultancy
  class JourneyController < ::JourneyController
    require_permission :management_consultancy

    def journey_class
      Journey
    end
  end
end
