class AddIndexToProcurementBuildingServices < ActiveRecord::Migration[5.2]
  def change
    add_index :facilities_management_procurement_building_services, %i[facilities_management_procurement_building_id code], name: 'idx_fm_pbs_on_fm_pb_and_code'
  end
end
