module FacilitiesManagement::ProcurementsHelper
  def journey_step_url_former(journey_step:, region_codes: nil, service_codes: nil)
    "/facilities-management/choose-#{journey_step}?#{{ region_codes: region_codes }.to_query}&#{{ service_codes: service_codes }.to_query}"
  end

  def does_form_for_current_step_require_special_client_validation?(params)
    %i[contract_name contract_dates estimated_annual_cost pension_funds security_policy_document].include? params[:step].try(:to_sym)
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
                        quick_search: 'Quick search',
                        detailed_search: 'Detailed search',
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

  def procurement_can_be_deleted?
    %w[quick_search detailed_search da_draft choose_contract_value results].include? @procurement.aasm_state
  end
end
