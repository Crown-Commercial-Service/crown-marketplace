class AddAddress1Address2CountyAndRegionToSupplyTeachersBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :supply_teachers_branches, :address_1, :string
    add_column :supply_teachers_branches, :address_2, :string
    add_column :supply_teachers_branches, :county, :string
    add_column :supply_teachers_branches, :region, :string
  end
end
