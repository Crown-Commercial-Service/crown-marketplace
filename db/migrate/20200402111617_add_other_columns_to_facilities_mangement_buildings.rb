class AddOtherColumnsToFacilitiesMangementBuildings < ActiveRecord::Migration[5.2]
  class FacilitiesManagementBuilding < ApplicationRecord
  end

  def up
    add_column :facilities_management_buildings, :other_building_type, :string
    add_column :facilities_management_buildings, :other_security_type, :string

    FacilitiesManagementBuilding.find_each do |building|
      building.user_id = User.find_by(email: Base64.decode64(building.user_email))&.id
      building.save!
    end
  end

  def down
    remove_column :facilities_management_buildings, :other_building_type, :string
    remove_column :facilities_management_buildings, :other_security_type, :string

    FacilitiesManagementBuilding.find_each do |building|
      building.user_id = nil
      building.save!
    end
  end
end
