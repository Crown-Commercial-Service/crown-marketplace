class CreateFacilitiesManagementServices < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_services, id: false do |t|
      t.primary_key :code, :string, limit: 5
      t.references :facilities_management_rm6232_work_package, type: :string, limit: 1, null: false, index: { name: 'index_rm6232_fm_services_on_fm_work_packages_code' }
      t.string :name, limit: 100
      t.text :description
      t.boolean :total
      t.boolean :hard
      t.boolean :soft
      t.integer :sort_order
      t.timestamps

      t.index :code
      t.index :total
      t.index :hard
      t.index :soft
      t.index :sort_order
    end

    rename_column :facilities_management_rm6232_services, :facilities_management_rm6232_work_package_id, :work_package_code
    add_foreign_key :facilities_management_rm6232_services, :facilities_management_rm6232_work_packages, column: :work_package_code, primary_key: :code
  end
end
