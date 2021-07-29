class CreateFacilitiesManagementSector < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_sectors do |t|
      t.string :name, limit: 30
      t.timestamps
    end
  end
end
