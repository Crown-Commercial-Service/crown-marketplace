module FacilitiesManagement::Beta::ProcurementsHelper
  def journey_step_url_former(journey_step:, region_codes: nil, service_codes: nil)
    "/facilities-management/choose-#{journey_step}?#{{ region_codes: region_codes }.to_query}&#{{ service_codes: service_codes }.to_query}"
  end
end
