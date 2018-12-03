module ManagementConsultancy
  class JourneyController < ::JourneyController
    require_framework_permission :management_consultancy

    def journey_class
      Journey
    end
  end
end
