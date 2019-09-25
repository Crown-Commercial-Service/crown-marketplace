class FacilitiesManagement::ProcurementRouter
  include Rails.application.routes.url_helpers

  STEPS = %w[contract_name estimated_annual_cost tupe].freeze

  def initialize(id:, step: nil)
    @id = id
    @step = step
  end

  def route
    return facilities_management_beta_procurement_path(id: @id) if next_step.nil?

    edit_facilities_management_beta_procurement_path(id: @id, step: next_step)
  end

  private

  def next_step
    return nil if @step.nil?

    return nil unless STEPS.include? @step

    return nil if @step == STEPS.last

    STEPS[STEPS.find_index(@step) + 1]
  end
end
