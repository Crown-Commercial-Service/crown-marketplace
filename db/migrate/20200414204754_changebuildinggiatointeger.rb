class Changebuildinggiatointeger < ActiveRecord::Migration[5.2]
  def up
    change_column :facilities_management_buildings, :gia, :integer
  end

  def down
    change_column :facilities_management_buildings, :gia, :integer
  end
end
