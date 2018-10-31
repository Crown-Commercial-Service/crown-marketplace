class CreateFacilitiesManagementSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_suppliers, id: :uuid do |t|
      t.text :name, null: false
      t.timestamps
    end
  end
end
