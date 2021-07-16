class AddUniqueIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :facilities_management_supplier_details, :supplier_name, unique: true
    add_index :facilities_management_buildings, %i[user_id building_name], unique: true, name: 'index_building_bulding_name_and_user_id'
    add_index :facilities_management_procurement_pension_funds, %i[name facilities_management_procurement_id], unique: true, name: 'index_pension_funds_name_and_procurement_id'
    add_index :facilities_management_regional_availabilities, %i[lot_number region_code facilities_management_supplier_id], unique: true, name: 'index_regional_availabilities_on_lot_number_and_region_code'
    add_index :facilities_management_service_offerings, %i[lot_number service_code facilities_management_supplier_id], unique: true, name: 'index_service_offerings_on_lot_number_and_service_code'
  end
end
