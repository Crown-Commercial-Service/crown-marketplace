module FacilitiesManagement
    class Beta::SummaryController < FacilitiesManagement::HomeController
      def guidance
        render plain: 'guidance test'
      end
    end
  end
