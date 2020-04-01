class AddFieldsToFacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :facilities_management_buildings do |table|
        dir.up do
          add_columns_to table
          table.rename :user_id, :user_email
          table.column :user_id, :uuid, index: true
        end
        dir.down do
          remove_columns_from table
          table.remove :user_id
          table.rename :user_email, :user_id
        end
      end
    end
  end

  def add_columns_to(table)
    table.text :building_ref
    table.text :building_name
    table.text :description
    table.numeric :gia
    table.text :region
    table.text :building_type
    table.text :security_type
    table.text :address_town
    table.text :address_county
    table.text :address_line_1
    table.text :address_line_2
    table.text :address_postcode
    table.text :address_region
    table.text :address_region_code
  end

  def remove_columns_from(table)
    table.remove :building_ref
    table.remove :building_name
    table.remove :description
    table.remove :gia
    table.remove :region
    table.remove :building_type
    table.remove :security_type
    table.remove :address_town
    table.remove :address_county
    table.remove :address_line_1
    table.remove :address_line_2
    table.remove :address_postcode
    table.remove :address_region
    table.remove :address_region_code
  end
end
