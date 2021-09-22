class ConfirmDropFacilitiesManagementRegions < ActiveRecord::Migration[6.0]
  def up
    drop_table :facilities_management_regions if ActiveRecord::Base.connection.table_exists? 'facilities_management_regions'
  end

  def down; end
end
