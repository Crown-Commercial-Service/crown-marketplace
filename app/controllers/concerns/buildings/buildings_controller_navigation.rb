module Buildings::BuildingsControllerNavigation
  extend ActiveSupport::Concern

  STEPS = {
    new: { description: 'Building details', position: 1, next: :gia },
    building_details: { description: 'Building details', position: 1, next: :gia },
    add_address: { position: 1 },
    gia: { description: 'Building size', position: 2, next: :type, previous: :building_details },
    type: { description: 'Building type', position: 3, next: :security, previous: :gia },
    security: { description: 'Security clearance', position: 4, next: :show, previous: :type },
    show: { description: 'Building details summary' }
  }.freeze

  def step_title(action_name)
    t('facilities_management.buildings.step_title.step_title', position: STEPS.dig(action_name, :position))
  end

  def step_footer(action_name)
    t('facilities_management.buildings.step_footer.step_footer', description: STEPS[next_step(action_name)][:description])
  end

  def next_step(action_name)
    STEPS[action_name][:next]
  end

  def previous_step(action_name)
    STEPS[action_name][:previous]
  end

  def next_link(save_and_return, step)
    if save_and_return || step == 'security'
      facilities_management_building_path(@page_data[:model_object].id)
    else
      edit_facilities_management_building_path(@page_data[:model_object].id, step: next_step(step.to_sym).to_s)
    end
  end
end
