# rubocop:disable Metrics/ModuleLength
module FacilitiesManagement::ProcurementsHelper
  def journey_step_url_former(journey_step:, region_codes: nil, service_codes: nil)
    "/facilities-management/choose-#{journey_step}?#{{ region_codes: region_codes }.to_query}&#{{ service_codes: service_codes }.to_query}"
  end

  def initial_call_off_period_start_date
    format_date @procurement.initial_call_off_start_date
  end

  def initial_call_off_period_end_date
    return '' if @procurement.initial_call_off_start_date.blank?

    Date.parse(@procurement.initial_call_off_start_date.to_s).next_year(@procurement.initial_call_off_period) - 1
  end

  def mobilisation_period
    result = ''
    period = @procurement.mobilisation_period
    result = "#{period} #{'week'.pluralize(period)}" if @procurement.mobilisation_period_required == true
    result = '' if @procurement.mobilisation_period_required.blank?
    result = 'None' if @procurement.mobilisation_period_required == false
    result
  end

  def mobilisation_start_date
    start_date = Date.parse(@procurement.initial_call_off_start_date.to_s) - 1
    start_date - (@procurement.mobilisation_period * 7)
  end

  def mobilisation_end_date
    Date.parse(@procurement.initial_call_off_start_date.to_s) - 1
  end

  def initial_call_off_period(period)
    period.to_s + (period > 1 ? ' years' : ' year') unless period.nil?
  end

  def format_extension(start_date, end_date)
    "#{format_date start_date} to #{format_date end_date}"
  end

  def any_service_codes(procurement_buildings)
    procurement_buildings.map(&:service_codes).flatten.reject(&:blank?).any?
  end

  def building_services_status?(status)
    return t('common.incomplete') unless status == true

    t('common.complete')
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

  def mobilisation_period_description
    format_extension(mobilisation_start_date, mobilisation_end_date)
  end

  def initial_call_off_period_description
    format_extension(@procurement.initial_call_off_start_date, initial_call_off_period_end_date)
  end

  def extension_period_description(period)
    format_extension(@procurement.send("extension_period_#{period}_start_date"), @procurement.send("extension_period_#{period}_end_date"))
  end

  def mobilisation_period_error_case
    if @procurement.errors[:mobilisation_period].any?
      0
    elsif @procurement.errors[:mobilisation_start_date].any?
      1
    else
      2
    end
  end

  def to_lower_case(str)
    return str if !/[[:upper:]]/.match(str[0]).nil? && !/[[:upper:]]/.match(str[1]).nil?

    str[0] = str[0].downcase
    str
  end

  def sort_by_pension_fund_created_at
    # problem was for pension funds with duplicated names,the validation has an error so there is no created_at
    parts = @procurement.procurement_pension_funds.partition { |o| o.created_at.nil? }
    parts.last.sort_by(&:created_at) + parts.first
  end

  def procurement_building_errors
    @procurement.errors.details[:"procurement_buildings.service_codes"].map { |error| error[:building_id] }
  end

  def building_tab_class(building, index)
    css_class = ''
    css_class << 'active' if index.zero?
    css_class << ' govuk-form-group--error' if procurement_building_errors.include? building.id
    css_class
  end

  def display_building_services_error(procurement_building)
    return if procurement_building.errors.empty?

    error = procurement_building.errors

    content_tag :span, id: "#{procurement_building.building.building_name}-#{error.details[:service_codes].first[:error]}-error", class: 'govuk-error-message' do
      error[:service_codes].first.to_s
    end
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

  def procurement_buildings_requiring_service_info(procurement)
    procurement.active_procurement_buildings.order_by_building_name.select(&:requires_service_questions?)
  end

  def procurement_building_row(form, building)
    if building.status == 'Ready'
      content_tag(:div, class: 'govuk-checkboxes govuk-checkboxes--small') do
        content_tag(:div, class: 'govuk-checkboxes__item') do
          capture do
            concat(form.check_box(:active, class: 'govuk-checkboxes__input', title: building.building_name, checked: @building_params[building.id] == '1'))
            concat(form.label(:active, class: 'govuk-label govuk-checkboxes__label govuk-!-padding-top-0') do
              procurement_building_checkbox_text(building)
            end)
          end
        end
      end
    else
      content_tag(:div, class: 'govuk-!-padding-left-7') do
        procurement_building_checkbox_text(building)
      end
    end
  end

  def procurement_building_checkbox_text(building)
    capture do
      concat(content_tag(:span, building.building_name, class: 'govuk-fieldset__legend'))
      concat(content_tag(:span, building.address_no_region, class: 'govuk-hint govuk-!-margin-bottom-0'))
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

        concat(content_tag(:span, errors[attribute].to_s, id: error_id(attribute), class: 'govuk-error-message'))
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

  def section_id(section)
    section.downcase.gsub(' ', '-') + '-tag'
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
end
# rubocop:enable Metrics/ModuleLength
