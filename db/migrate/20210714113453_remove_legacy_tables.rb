class RemoveLegacyTables < ActiveRecord::Migration[6.0]
  def up
    drop_table :legal_services_admin_uploads
    drop_table :legal_services_regional_availabilities
    drop_table :legal_services_service_offerings
    drop_table :legal_services_suppliers
    drop_table :legal_services_uploads
    drop_table :management_consultancy_admin_uploads
    drop_table :management_consultancy_rate_cards
    drop_table :management_consultancy_regional_availabilities
    drop_table :management_consultancy_service_offerings
    drop_table :management_consultancy_suppliers
    drop_table :management_consultancy_uploads
    drop_table :supply_teachers_admin_current_data
    drop_table :supply_teachers_admin_uploads
    drop_table :supply_teachers_branches
    drop_table :supply_teachers_rates
    drop_table :supply_teachers_suppliers
    drop_table :supply_teachers_uploads
  end

  def down; end
end
