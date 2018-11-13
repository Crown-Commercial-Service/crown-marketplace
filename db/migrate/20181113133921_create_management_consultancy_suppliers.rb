class CreateManagementConsultancySuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :management_consultancy_suppliers, id: :uuid do |t|
      t.text :name, null: false
      t.timestamps
    end
  end
end
