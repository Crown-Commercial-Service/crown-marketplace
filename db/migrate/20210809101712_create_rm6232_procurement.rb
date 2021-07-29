class CreateRM6232Procurement < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_procurements, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid, null: false, index: { name: 'index_fm_rm6232_procurements_on_user_id' }
      t.string :aasm_state, limit: 30
      t.text :service_codes, array: true, default: []
      t.text :region_codes, array: true, default: []
      t.integer :sector_code
      t.integer :estimated_contract_cost
      t.string :contract_name, limit: 100
      t.timestamps
    end
  end
end
