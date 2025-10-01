module FacilitiesManagement::RM6378
  module ProcurementsHelper
    def journey_step_url_former(journey_slug:, annual_contract_value: nil, region_codes: nil, service_codes: nil)
      facilities_management_journey_question_path(framework: 'RM6378', slug: journey_slug, annual_contract_value: annual_contract_value, region_codes: region_codes, service_codes: service_codes)
    end
  end
end
