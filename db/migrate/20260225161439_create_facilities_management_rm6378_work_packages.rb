class CreateFacilitiesManagementRM6378WorkPackages < ActiveRecord::Migration[8.1]
  def change
    create_table :facilities_management_rm6378_work_packages do |t|
      t.string :code
      t.string :name
      t.boolean :selectable
    end
  end
end
