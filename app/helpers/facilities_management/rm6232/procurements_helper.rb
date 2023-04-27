module FacilitiesManagement::RM6232
  module ProcurementsHelper
    def page_subtitle
      "#{current_contract_name} - #{@procurement.contract_number}"
    end

    def current_contract_name
      @procurement.errors.include?(:contract_name) ? @procurement.class.find(params[:id] || params[:procurement_id]).contract_name : @procurement.contract_name
    end

    def journey_step_url_former(journey_slug:, annual_contract_value: nil, region_codes: nil, service_codes: nil)
      facilities_management_journey_question_path(framework: 'RM6232', slug: journey_slug, annual_contract_value: annual_contract_value, region_codes: region_codes, service_codes: service_codes)
    end

    def link_url(section)
      case section
      when 'contract_period', 'services', 'buildings', 'buildings_and_services'
        facilities_management_rm6232_procurement_procurement_detail_path(procurement_id: @procurement.id, section: section.dasherize)
      else
        edit_facilities_management_rm6232_procurement_procurement_detail_path(procurement_id: @procurement.id, section: section.dasherize)
      end
    end

    def procurement_service_names
      @procurement_service_names ||= @procurement.procurement_services.pluck(:name)
    end
  end
end
