class CreateFacilitiesManagementWorkPackages < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_work_packages, id: false do |t|
      t.primary_key :code, :string, limit: 1
      t.string :name, limit: 100
      t.boolean :selectable
      t.timestamps

      t.index :code
      t.index :selectable
    end
  end
end
