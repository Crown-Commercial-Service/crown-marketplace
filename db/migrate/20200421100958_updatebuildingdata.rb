class Updatebuildingdata < ActiveRecord::Migration[5.2]
  def up
    FacilitiesManagement::Building.all.each do |building|
      building.updated_at = Time.current
      building.save!(validate: false)
    end
  end

  def down
    # do nothing
  end
end
