module FacilitiesManagement
  class Beta::SummaryController < FacilitiesManagement::HomeController
    def guidance
      # render plain: 'guidance test'
    end

    def suppliers
      render plain: 'shortlisted DA suppliers'
    end
  end
end
