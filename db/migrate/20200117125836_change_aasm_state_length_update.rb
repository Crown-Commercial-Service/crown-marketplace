class ChangeAasmStateLengthUpdate < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :facilities_management_procurements do |t|
        dir.up { t.change :aasm_state, :string, limit: 30 }
        dir.down { t.change :aasm_state, :string, limit: 21 }
      end
    end
  end
end
