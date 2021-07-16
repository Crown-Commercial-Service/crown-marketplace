class RenameTablesToAddRM3830 < ActiveRecord::Migration[6.0]
  def change
    rename_index :facilities_management_management_reports, :index_facilities_management_management_reports_on_user_id,     :index_fm_rm3830_management_reports_on_user_id
    rename_index :facilities_management_supplier_details,   :index_facilities_management_supplier_details_on_contact_email, :index_fm_rm3830_supplier_details_on_contact_email
    rename_index :facilities_management_supplier_details,   :index_facilities_management_supplier_details_on_supplier_name, :index_fm_rm3830_supplier_details_on_supplier_name

    rename_table :facilities_management_procurements,                             :facilities_management_rm3830_procurements
    rename_table :facilities_management_procurement_building_service_lifts,       :facilities_management_rm3830_procurement_building_service_lifts
    rename_table :facilities_management_procurement_building_services,            :facilities_management_rm3830_procurement_building_services
    rename_table :facilities_management_procurement_buildings,                    :facilities_management_rm3830_procurement_buildings
    rename_table :facilities_management_procurement_contact_details,              :facilities_management_rm3830_procurement_contact_details
    rename_table :facilities_management_procurement_optional_call_off_extensions, :facilities_management_rm3830_procurement_call_off_extensions
    rename_table :facilities_management_procurement_pension_funds,                :facilities_management_rm3830_procurement_pension_funds
    rename_table :facilities_management_procurement_suppliers,                    :facilities_management_rm3830_procurement_suppliers
    rename_table :facilities_management_spreadsheet_imports,                      :facilities_management_rm3830_spreadsheet_imports
    rename_table :facilities_management_admin_uploads,                            :facilities_management_rm3830_admin_uploads
    rename_table :facilities_management_management_reports,                       :facilities_management_rm3830_admin_management_reports
    rename_table :facilities_management_supplier_details,                         :facilities_management_rm3830_supplier_details
    rename_table :fm_frozen_rate_cards,                                           :facilities_management_rm3830_frozen_rate_cards
    rename_table :fm_frozen_rates,                                                :facilities_management_rm3830_frozen_rates
    rename_table :fm_rate_cards,                                                  :facilities_management_rm3830_rate_cards
    rename_table :fm_rates,                                                       :facilities_management_rm3830_rates
    rename_table :fm_static_data,                                                 :facilities_management_rm3830_static_data

    rename_table :fm_regions,         :facilities_management_regions
    rename_table :fm_security_types,  :facilities_management_security_types
  end
end
