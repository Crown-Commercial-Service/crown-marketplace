module FacilitiesManagement::RM6232
  module ProcurementsHelper
    include FacilitiesManagement::ProcurementsHelper

    def page_subtitle
      "#{current_contract_name} - #{@procurement.contract_number}"
    end

    def current_contract_name
      @procurement.errors.include?(:contract_name) ? @procurement.class.find(params[:id] || params[:procurement_id]).contract_name : @procurement.contract_name
    end

    def journey_step_url_former(journey_slug:, annual_contract_value: nil, region_codes: nil, service_codes: nil)
      facilities_management_journey_question_path(framework: 'RM6232', slug: journey_slug, annual_contract_value: annual_contract_value, region_codes: region_codes, service_codes: service_codes)
    end
  end
end
