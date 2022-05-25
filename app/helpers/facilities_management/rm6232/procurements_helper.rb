module FacilitiesManagement::RM6232
  module ProcurementsHelper
    include FacilitiesManagement::ProcurementsHelper

    def journey_step_url_former(journey_slug:, annual_contract_value: nil, region_codes: nil, service_codes: nil)
      facilities_management_journey_question_path(framework: 'RM6232', slug: journey_slug, annual_contract_value: annual_contract_value, region_codes: region_codes, service_codes: service_codes)
    end

    def link_url(section)
      case section
      when 'contract_period', 'services', 'buildings', 'buildings_and_services'
        # TODO: Add the summary section
        # facilities_management_rm6232_procurement_summary_path(@procurement, summary: section)
        '#summary'
      else
        '#edit'
        # edit_facilities_management_rm6232_procurement_path(@procurement, step: section)
      end
    end
  end
end
