class AddServiceCodesRegionCodesToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :service_codes, :text, array: true, default: []
    add_column :facilities_management_procurements, :region_codes, :text, array: true, default: []
  end
end
