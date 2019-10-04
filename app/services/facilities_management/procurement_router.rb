class FacilitiesManagement::ProcurementRouter
  include Rails.application.routes.url_helpers

  STEPS = %w[contract_name estimated_annual_cost tupe contract_dates].freeze

  def initialize(id:, procurement_state:, step: nil)
    @id = id
    @procurement_state = procurement_state
    @step = step
  end

  def route
    return facilities_management_beta_procurements_path if @procurement_state == 'quick_search'
    return facilities_management_beta_procurement_path(id: @id) if next_step.nil?

    edit_facilities_management_beta_procurement_path(id: @id, step: next_step)
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
