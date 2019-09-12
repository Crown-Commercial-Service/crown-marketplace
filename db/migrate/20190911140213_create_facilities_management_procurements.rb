class CreateFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurements, id: :uuid do |t|
      t.references  :user,
                    foreign_key: true, type: :uuid, null: false,
                    index: { name: 'index_facilities_management_procurements_on_user_id' }
      t.string  :name, limit: 100
      t.string  :aasm_state, limit: 15
      t.string  :updated_by, limit: 100
      t.jsonb   :procurement_data

      t.timestamps
    end
  end
end
