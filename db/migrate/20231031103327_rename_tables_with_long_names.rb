class RenameTablesWithLongNames < ActiveRecord::Migration[7.1]
  def change
    ActiveRecord::Base.connection.tables.each do |table_name|
      puts "----- #{table_name} -----"
      puts ActiveRecord::Base.connection.columns(table_name).map(&:name)
    end

    rename_table :facilities_management_rm3830_procurement_building_service_lifts, :facilities_management_procurement_building_service_lifts
    rename_table :facilities_management_rm3830_procurement_call_off_extensions, :facilities_management_rm3830_procurement_extensions
    rename_table :facilities_management_rm6232_procurement_call_off_extensions, :facilities_management_rm6232_procurement_extensions
  end
end
