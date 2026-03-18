module FacilitiesManagement::RM6378
  module ProcurementsHelper
    # rubocop:disable Metrics/ParameterLists
    def journey_step_url_former(journey_slug:, private_finance_initiative: nil, estimated_contract_duration: nil, annual_contract_value: nil, contract_start_date: nil, region_codes: nil, service_codes: nil)
      facilities_management_journey_question_path(framework: 'RM6378', slug: journey_slug, private_finance_initiative: private_finance_initiative, estimated_contract_duration: estimated_contract_duration, contract_start_date_yyyy: contract_start_date&.year, contract_start_date_mm: contract_start_date&.month, contract_start_date_dd: contract_start_date&.day, annual_contract_value: annual_contract_value, region_codes: region_codes, service_codes: service_codes)
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
