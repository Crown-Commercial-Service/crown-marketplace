class FacilitiesManagement::ProcurementRouter
  include Rails.application.routes.url_helpers

  QUICK_SEARCH_EDIT_STEPS = %w[regions services].freeze

  STEPS = %w[contract_name estimated_annual_cost tupe contract_dates procurement_buildings building_services services].freeze

  def initialize(id:, procurement_state:, step: nil)
    @id = id
    @procurement_state = procurement_state
    @step = step
  end

  def route
    if @procurement_state == 'quick_search'
      return QUICK_SEARCH_EDIT_STEPS.include?(@step) ? edit_facilities_management_beta_procurement_path(id: @id) : facilities_management_beta_procurements_path
    end
    return edit_facilities_management_beta_procurement_path(id: @id, step: previous_step) if @step == 'services'
    return facilities_management_beta_procurement_building_path(FacilitiesManagement::Procurement.find_by(id: @id).procurement_buildings.first) if @step == 'building_services'

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
