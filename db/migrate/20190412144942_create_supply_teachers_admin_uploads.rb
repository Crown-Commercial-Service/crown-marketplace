class CreateSupplyTeachersAdminUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :supply_teachers_admin_uploads, id: :uuid do |t|
      t.string :aasm_state, limit: 15
      t.string :current_accredited_suppliers, limit: 255
      t.string :geographical_data_all_suppliers, limit: 255
      t.string :lot_1_and_lot_2_comparisons, limit: 255
      t.string :master_vendor_contacts, limit: 255
      t.string :neutral_vendor_contacts, limit: 255
      t.string :pricing_for_tool, limit: 255
      t.string :supplier_lookup, limit: 255
      t.text :fail_reason

      t.timestamps
    end
  end
end
