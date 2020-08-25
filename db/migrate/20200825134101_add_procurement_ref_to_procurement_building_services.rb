class AddProcurementRefToProcurementBuildingServices < ActiveRecord::Migration[5.2]
  def change
    add_reference :facilities_management_procurement_building_services, :facilities_management_procurement, foreign_key: true, type: :uuid,
                                                                                                            index: { name: 'index_fm_procurement_building_services_on_fm_procurement_id' }
    add_index :facilities_management_procurement_building_services, %i[facilities_management_procurement_id facilities_management_procurement_building_id], name: 'idx_fm_pbs_fm_p_fm_pb'
  end
end
