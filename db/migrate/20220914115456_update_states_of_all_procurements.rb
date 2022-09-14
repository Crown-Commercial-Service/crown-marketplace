class UpdateStatesOfAllProcurements < ActiveRecord::Migration[6.0]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    FacilitiesManagement::RM6232::Procurement.where.not(aasm_state: 'what_happens_next').update_all(aasm_state: 'what_happens_next')
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down; end
end
