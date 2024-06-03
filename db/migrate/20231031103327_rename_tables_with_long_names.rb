class RenameTablesWithLongNames < ActiveRecord::Migration[7.1]
  def change
    # ActiveRecord::Base.connection.tables.each do |table_name|
    #   puts "----- #{table_name} -----"
    #   puts ActiveRecord::Base.connection.columns(table_name).map(&:name)
    # end

    # puts "facilities_management_rm3830_procurement_building_service_lifts exists?"
    # puts ActiveRecord::Base.connection.table_exists? 'facilities_management_rm3830_procurement_building_service_lifts'
    # puts "facilities_management_rm3830_procurement_call_off_extensions exists?"
    # puts ActiveRecord::Base.connection.table_exists? 'facilities_management_rm3830_procurement_call_off_extensions'
    # puts "facilities_management_rm6232_procurement_call_off_extensions exists?"
    # puts ActiveRecord::Base.connection.table_exists? 'facilities_management_rm6232_procurement_call_off_extensions'


    puts "--- LIST INDEX NAMES THAT WE CARE ABOUT ---"
    %w[
      facilities_management_rm3830_procurement_building_service_lifts
      facilities_management_rm3830_procurement_call_off_extensions
      facilities_management_rm6232_procurement_call_off_extensions
    ].each do |table|
      indexes = ActiveRecord::Base.connection.indexes(table)
      "Indicies for: #{table}"
      if indexes.length > 0
        puts "====>  #{table} <===="
        indexes.each do |index|
          puts "----> #{index.name}"
        end
        puts "====>  #{table} <===="
        2.times{ puts ''}
      end
    end

    # exec_query "ALTER TABLE #{quote_table_name(table_name)} RENAME TO #{quote_table_name(new_name)}"

    # execute "ALTER INDEX fundrise_stories_pkey RENAME TO fundraise_stories_pkey;"

    rename_table :facilities_management_rm3830_procurement_building_service_lifts, :facilities_management_procurement_building_service_lifts
    rename_table :facilities_management_rm3830_procurement_call_off_extensions, :facilities_management_rm3830_procurement_extensions
    rename_table :facilities_management_rm6232_procurement_call_off_extensions, :facilities_management_rm6232_procurement_extensions
  end
end
