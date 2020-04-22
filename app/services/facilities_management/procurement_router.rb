class FacilitiesManagement::ProcurementRouter
  include Rails.application.routes.url_helpers

  QUICK_SEARCH_EDIT_STEPS = %w[regions services].freeze

  STEPS = %w[contract_name estimated_annual_cost tupe contract_dates procurement_buildings building_services services].freeze

  def initialize(id:, procurement_state:, step: nil, da_journey_state: nil)
    @id = id
    @procurement_state = procurement_state
    @da_journey_state = da_journey_state
    @step = step
  end

  STATES_TO_VIEWS = {
    'choose_contract_value': 'choose_contract_value',
    'results': 'results',
    'da_draft': 'direct_award',
    'further_competition': 'further_competition'
  }.freeze

  DA_JOURNEY_STATES_TO_VIEWS = {
    'pricing': 'pricing',
    'what_next': 'what_next',
    'payment_method': 'payment_method',
    'invoicing_contact_details': 'invoicing_contact_details',
    'new_invoicing_contact_details': 'new_invoicing_contact_details',
    'new_invoicing_address': 'new_invoicing_address',
    'authorised_representative': 'authorised_representative',
    'new_authorised_representative_details': 'new_authorised_representative_details',
    'new_authorised_representative_address': 'new_authorised_representative_address',
    'notices_contact_details': 'notices_contact_details',
    'new_notices_contact_details': 'new_notices_contact_details',
    'new_notices_address': 'new_notices_address',
    'security_policy_document': 'security_policy_document',
    'local_government_pension_scheme': 'local_government_pension_scheme',
    'important_information': 'did_you_know',
    'contract_details': 'contract_details',
    'review_and_generate': 'review_and_generate_documents',
    'review': 'review_contract',
    'sending': 'sending_the_contract',
    'pension_funds': 'pension_funds'
  }.freeze

  def da_journey_view
    return DA_JOURNEY_STATES_TO_VIEWS[@step.to_sym] if @step.present? && DA_JOURNEY_STATES_TO_VIEWS.key?(@step.to_sym)

    DA_JOURNEY_STATES_TO_VIEWS[@da_journey_state.to_sym] if DA_JOURNEY_STATES_TO_VIEWS.key?(@da_journey_state.to_sym)
  end

  def view
    return STATES_TO_VIEWS[@procurement_state.to_sym] if STATES_TO_VIEWS.key?(@procurement_state.to_sym)

    'detailed_search_summary'
  end

  def route
    if @procurement_state == 'quick_search'
      return QUICK_SEARCH_EDIT_STEPS.include?(@step) ? edit_facilities_management_beta_procurement_path(id: @id) : facilities_management_beta_procurements_path
    end
    return edit_facilities_management_beta_procurement_path(id: @id, step: previous_step) if @step == 'services'
    return facilities_management_beta_procurement_building_path(FacilitiesManagement::Procurement.find_by(id: @id).active_procurement_buildings.first) if @step == 'building_services'

    next_step.nil? ? facilities_management_beta_procurement_path(id: @id) : edit_facilities_management_beta_procurement_path(id: @id, step: next_step)
  end

  def back_link
    return facilities_management_beta_procurement_path(id: @id) if previous_step.nil?

    edit_facilities_management_beta_procurement_path(id: @id, step: previous_step)
  end

  private

  def next_step
    return nil if @step.nil?

    return nil unless STEPS.include? @step

    return nil if @step == STEPS.last

    STEPS[STEPS.find_index(@step) + 1]
  end

  def previous_step
    return nil if @step.nil?

    return nil unless STEPS.include? @step

    return nil if @step == STEPS.first

    STEPS[STEPS.find_index(@step) - 1]
  end
end
