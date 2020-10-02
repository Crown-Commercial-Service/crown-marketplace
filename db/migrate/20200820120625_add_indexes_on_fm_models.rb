class AddIndexesOnFmModels < ActiveRecord::Migration[5.2]
  def change
    add_index :facilities_management_procurement_buildings, :building_id, name: 'index_fm_procurement_buildings_on_building_id'
    add_index :facilities_management_procurement_buildings, :active, name: 'index_fm_procurement_buildings_on_active'
    add_index :facilities_management_procurement_buildings, :service_codes, name: 'index_fm_procurement_buildings_on_service_codes'
    add_index :facilities_management_procurement_building_services, :code, name: 'index_fm_procurement_building_services_on_code'
    add_index :fm_rates, %i[code standard]
  end
end
