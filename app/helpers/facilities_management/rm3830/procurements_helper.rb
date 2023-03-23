module FacilitiesManagement::RM3830
  module ProcurementsHelper
    include FacilitiesManagement::ContractDatesHelper
    include FacilitiesManagement::ProcurementsHelper

    def journey_step_url_former(journey_step:, framework:, region_codes: nil, service_codes: nil)
      facilities_management_journey_question_path(framework: framework, slug: "choose-#{journey_step}", region_codes: region_codes, service_codes: service_codes)
    end

    PROCUREMENT_STATE = { da_draft: 'DA draft',
                          further_competition: 'Further competition',
                          results: 'Results',
                          quick_search: 'Quick view',
                          detailed_search: 'Entering requirements',
                          detailed_search_bulk_upload: 'Entering requirements',
                          closed: 'closed' }.freeze

    def procurement_state(procurement_state)
      return procurement_state.humanize unless PROCUREMENT_STATE.key?(procurement_state.to_sym)

      PROCUREMENT_STATE[procurement_state.to_sym]
    end

    def sort_by_pension_fund_created_at
      # problem was for pension funds with duplicated names,the validation has an error so there is no created_at
      parts = @procurement.procurement_pension_funds.partition { |o| o.created_at.nil? }
      parts.last.sort_by(&:created_at) + parts.first
    end

    def continue_button_text
      ProcurementRouter::SUMMARY.include?(params[:step]) ? 'save_and_continue' : 'save_and_return'
    end

    def requires_back_link?
      %w[contract_name estimated_annual_cost tupe buildings].include? params[:step]
    end

    def link_url(section)
      case section
      when 'contract_period', 'services', 'buildings', 'buildings_and_services', 'service_requirements'
        facilities_management_rm3830_procurement_procurement_detail_path(procurement_id: @procurement.id, section: section.dasherize)
      else
        edit_facilities_management_rm3830_procurement_procurement_detail_path(procurement_id: @procurement.id, section: section.dasherize)
      end
    end

    def work_packages_names
      @work_packages_names ||= StaticData.work_packages.to_h { |wp| [wp['code'], wp['name']] }
    end

    def number_of_suppliers
      @procurement.procurement_suppliers.count
    end

    def procurement_services
      @procurement_services ||= @procurement.procurement_building_services.pluck(:name).uniq
    end

    def lowest_supplier_price
      @procurement.procurement_suppliers.minimum(:direct_award_value)
    end

    def suppliers
      @procurement.procurement_suppliers.map(&:supplier_name).sort
    end

    def unpriced_services
      @unpriced_services ||= @procurement.procurement_building_services_not_used_in_calculation
    end

    def service_codes
      @service_codes ||= @procurement.service_codes
    end

    def region_codes
      @region_codes ||= @procurement.region_codes
    end

    def services
      @services ||= Service.where(code: service_codes)&.sort_by { |service| service_codes.index(service.code) }
    end

    def regions
      FacilitiesManagement::Region.where(code: region_codes)
    end

    def suppliers_lot1a
      @suppliers_lot1a ||= SupplierDetail.long_list_suppliers_lot(region_codes, service_codes, '1a')
    end

    def suppliers_lot1b
      @suppliers_lot1b ||= SupplierDetail.long_list_suppliers_lot(region_codes, service_codes, '1b')
    end

    def suppliers_lot1c
      @suppliers_lot1c ||= SupplierDetail.long_list_suppliers_lot(region_codes, service_codes, '1c')
    end

    def supplier_count
      @supplier_count ||= SupplierDetail.supplier_count(region_codes, service_codes)
    end

    def further_competition_saved_date(procurement)
      format_date_time procurement.contract_datetime.to_datetime
    end

    CONTRACT_STATE = { sent: 'Awaiting supplier response',
                       accepted: 'Awaiting contract signature',
                       not_signed: 'Accepted, not signed',
                       declined: 'Supplier declined',
                       expired: 'No supplier response' }.freeze

    def contract_state_to_stage(state)
      CONTRACT_STATE[state.to_sym]
    end
  end
end
