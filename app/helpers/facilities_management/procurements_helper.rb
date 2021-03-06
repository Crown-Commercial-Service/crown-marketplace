# rubocop:disable Metrics/ModuleLength
module FacilitiesManagement::ProcurementsHelper
  include FacilitiesManagement::Procurements::ContractDatesHelper

  def journey_step_url_former(journey_step:, region_codes: nil, service_codes: nil)
    "/facilities-management/choose-#{journey_step}?#{{ region_codes: region_codes }.to_query}&#{{ service_codes: service_codes }.to_query}"
  end

  def initial_call_off_period_error?
    @procurement.errors[:initial_call_off_period_years].any? || @procurement.errors[:initial_call_off_period_months].any? || total_contract_period_error?
  end

  def total_contract_period_error?
    @total_contract_period_error ||= @procurement.errors[:base] && @procurement.errors.details[:base].any? { |error| error[:error] == :total_contract_period }
  end

  def extension_periods_error?
    %i[extensions_required optional_call_off_extensions.months optional_call_off_extensions.years optional_call_off_extensions.base].any? { |extension_error| @procurement.errors.keys.include? extension_error }
  end

  def total_contract_length_error?
    @total_contract_length_error ||= @procurement.errors[:base] && @procurement.errors.details[:base].any? { |error| error[:error] == :total_contract_length }
  end

  def display_extension_error_anchor
    error_list = []

    %i[years months base].each do |attribute|
      error_list << "optional_call_off_extensions.#{attribute}-error" if @procurement.errors.include?(:"optional_call_off_extensions.#{attribute}")
    end

    error_list.each do |error|
      concat(tag.span(id: error))
    end
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

  def buildings_with_missing_regions
    @buildings_with_missing_regions ||= @procurement.active_procurement_buildings.order_by_building_name.select(&:missing_region?)
  end

  def continue_button_text
    FacilitiesManagement::ProcurementRouter::SUMMARY.include?(params[:step]) ? 'save_and_continue' : 'save_and_return'
  end

  def service_name(service_code)
    services.select { |s| s['code'] == service_code }.first&.name&.humanize
  end

  def requires_back_link?
    %w[contract_name estimated_annual_cost tupe buildings].include? params[:step]
  end

  def address_in_a_line(building)
    [building.address_line_1, building.address_line_2, building.address_town].reject(&:blank?).join(', ') + " #{building.address_postcode}"
  end

  def procurement_building_row(form, building)
    if building.status == 'Ready'
      tag.div(class: 'govuk-checkboxes govuk-checkboxes--small') do
        tag.div(class: 'govuk-checkboxes__item') do
          capture do
            concat(form.check_box(:active, class: 'govuk-checkboxes__input', title: building.building_name, checked: @building_params[building.id] == '1'))
            concat(form.label(:active, class: 'govuk-label govuk-checkboxes__label govuk-!-padding-top-0') do
              procurement_building_checkbox_text(building)
            end)
          end
        end
      end
    else
      tag.div(class: 'govuk-!-padding-left-7') do
        procurement_building_checkbox_text(building)
      end
    end
  end

  def procurement_building_checkbox_text(building)
    capture do
      concat(tag.span(building.building_name, class: 'govuk-fieldset__legend'))
      concat(tag.span(building.address_no_region, class: 'govuk-hint govuk-!-margin-bottom-0'))
    end
  end

  def requirements_errors_list
    @requirements_errors_list ||= @procurement.errors.details[:base].map.with_index { |detail, index| [detail[:error], @procurement.errors[:base][index]] }.to_h
  end

  def section_errors(section)
    if section == 'contract_period'
      %i[contract_period_incomplete initial_call_off_period_in_past mobilisation_period_in_past mobilisation_period_required]
    else
      ["#{section}_incomplete".to_sym]
    end
  end

  def section_has_error?(section)
    return false unless @procurement.errors.any?

    (requirements_errors_list.keys & section_errors(section)).any?
  end

  def display_all_errors(errors, section_errors)
    capture do
      section_errors.each do |attribute|
        next unless errors[attribute]

        concat(tag.span(errors[attribute].to_s, id: error_id(attribute), class: 'govuk-error-message'))
      end
    end
  end

  def link_url(section)
    case section
    when 'contract_period', 'services', 'buildings', 'buildings_and_services', 'service_requirements'
      facilities_management_procurement_summary_path(@procurement, summary: section)
    else
      edit_facilities_management_procurement_path(@procurement, step: section)
    end
  end

  def optional_call_off_extensions
    @optional_call_off_extensions ||= @procurement.optional_call_off_extensions.sort_by(&:extension)
  end

  def optional_call_off_extension_visible?(extension)
    return false unless @procurement.extensions_required

    optional_call_off_extension = optional_call_off_extensions.find { |call_off_extension| call_off_extension.extension == extension }

    return false unless optional_call_off_extension

    optional_call_off_extension_meet_conditions?(optional_call_off_extension)
  end

  def optional_call_off_extension_meet_conditions?(optional_call_off_extension)
    optional_call_off_extension.extension_required || optional_call_off_extension.years.present? || optional_call_off_extension.months.present? || optional_call_off_extension.errors.any?
  end

  def section_id(section)
    "#{section.downcase.gsub(' ', '-')}-tag"
  end

  def work_packages_names
    @work_packages_names ||= FacilitiesManagement::StaticData.work_packages.map { |wp| [wp['code'], wp['name']] }.to_h
  end

  def active_procurement_buildings
    @active_procurement_buildings ||= @procurement.active_procurement_buildings.order_by_building_name
  end

  def number_of_suppliers
    @procurement.procurement_suppliers.count
  end

  def procurement_services
    @procurement_services ||= @procurement.procurement_building_services.map { |s| s[:name] }.uniq
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
    @services ||= FacilitiesManagement::Service.where(code: service_codes)&.sort_by { |service| service_codes.index(service.code) }
  end

  def regions
    FacilitiesManagement::Region.where(code: region_codes)
  end

  def suppliers_lot1a
    @suppliers_lot1a ||= FacilitiesManagement::SupplierDetail.long_list_suppliers_lot(region_codes, service_codes, '1a')
  end

  def suppliers_lot1b
    @suppliers_lot1b ||= FacilitiesManagement::SupplierDetail.long_list_suppliers_lot(region_codes, service_codes, '1b')
  end

  def suppliers_lot1c
    @suppliers_lot1c ||= FacilitiesManagement::SupplierDetail.long_list_suppliers_lot(region_codes, service_codes, '1c')
  end

  def supplier_count
    @supplier_count ||= FacilitiesManagement::SupplierDetail.supplier_count(region_codes, service_codes)
  end

  def further_competition_saved_date(procurement)
    format_date_time procurement.contract_datetime.to_datetime
  end
end
# rubocop:enable Metrics/ModuleLength
