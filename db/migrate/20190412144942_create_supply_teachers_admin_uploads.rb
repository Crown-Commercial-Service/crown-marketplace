class CreateSupplyTeachersAdminUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :supply_teachers_admin_uploads do |t|
      t.string :state
      t.string :current_accredited_suppliers
      t.string :geographical_data_all_suppliers
      t.string :lot_1_and_lot_2_comparisons
      t.string :master_vendor_contacts
      t.string :neutral_vendor_contacts
      t.string :pricing_for_tool
      t.string :supplier_lookup

      t.timestamps
    end
  end
end
