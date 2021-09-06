class UpdateTableForeignKeys < ActiveRecord::Migration[6.0]
  def change
    rename_column :facilities_management_rm3830_procurement_building_services,    :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_procurement_buildings,            :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_procurement_call_off_extensions,  :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_procurement_contact_details,      :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_procurement_pension_funds,        :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_procurement_suppliers,            :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_spreadsheet_imports,              :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_frozen_rate_cards,                :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id
    rename_column :facilities_management_rm3830_frozen_rates,                     :facilities_management_procurement_id, :facilities_management_rm3830_procurement_id

    rename_column :facilities_management_rm3830_procurement_building_service_lifts, :facilities_management_procurement_building_services_id, :facilities_management_rm3830_procurement_building_service_id

    rename_column :facilities_management_rm3830_procurement_building_services, :facilities_management_procurement_building_id, :facilities_management_rm3830_procurement_building_id
  end
end
