module ManagementConsultancy
  class JourneyController < ::JourneyController
    before_action { require_framework_permission :management_consultancy }

    def journey_class
      Journey
    end
  end
end
