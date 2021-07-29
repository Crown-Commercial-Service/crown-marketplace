module FacilitiesManagement::RM6232
  module ProcurementsHelper
    def journey_step_url_former(journey_step:, **url_parameters)
      "/facilities-management/RM6232/#{journey_step}?#{url_parameters.to_query}"
    end
  end
end
