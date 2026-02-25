class CreateFacilitiesManagementRM6378Services < ActiveRecord::Migration[8.1]
  def change
    create_table :facilities_management_rm6378_services do |t|
    t.string :work_package_code
      t.string :code
      t.string :name
      t.string :description
      t.string :category
      t.string "lot_id"
      t.string :number
      t.boolean "mandatory"
      t.boolean :hard, default: false
      t.boolean :soft, default: false
    end
  end
end
