class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers, id: :uuid do |t|
      t.text :name, null: false
      t.timestamps
    end
  end
end
