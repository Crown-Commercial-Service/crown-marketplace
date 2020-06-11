module BuildingsControllerNavigation
  extend ActiveSupport::Concern
  STEPS = {
    create: { position: 1, desc: '' },
    new: { position: 1, desc: '' },
    add_address: { position: 1, desc: '' },
    edit: { position: 1, desc: '' },
    update: { position: 1, desc: '' },
    gia: { position: 2, desc: 'Building size' },
    type: { position: 3, desc: 'Building type' },
    security: { position: 4, desc: 'Security clearance' }
  }.freeze

  def step_title(action_name)
    t('facilities_management.buildings.step_title.step_title', position: STEPS.dig(action_name.to_sym, :position), total: maximum_step_number)
  end

  def step_footer
    t('facilities_management.buildings.step_footer.step_footer', description: next_step[1][:desc]) if STEPS.dig(action_name.to_sym, :position).to_i < maximum_step_number
  end

  def maximum_step_number
    @maximum_step_number ||= STEPS.max_by { |_k, v| v[:position] }[1][:position]
  end

  def next_step(step = action_name)
    return STEPS.select { |_k, step_value| step_value[:position] == (STEPS.dig(step.to_sym, :position).to_i + 1) }.first if STEPS.dig(step.to_sym, :position).to_i < maximum_step_number

    STEPS[:edit]
  end
end
