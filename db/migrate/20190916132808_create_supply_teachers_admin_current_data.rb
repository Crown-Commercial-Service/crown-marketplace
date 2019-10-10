class CreateSupplyTeachersAdminCurrentData < ActiveRecord::Migration[5.2]
  def change
    create_table :supply_teachers_admin_current_data do |t|
      t.string :current_accredited_suppliers, limit: 255
      t.string :geographical_data_all_suppliers, limit: 255
      t.string :lot_1_and_lot_2_comparisons, limit: 255
      t.string :master_vendor_contacts, limit: 255
      t.string :neutral_vendor_contacts, limit: 255
      t.string :pricing_for_tool, limit: 255
      t.string :supplier_lookup, limit: 255
      t.string :data, limit: 255
      t.text :error
      t.timestamps
    end
  end
end
