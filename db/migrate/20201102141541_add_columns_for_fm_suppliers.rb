class AddColumnsForFmSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :fm_suppliers, :contact_name, :string
    add_column :fm_suppliers, :contact_email, :string
    add_column :fm_suppliers, :contact_phone, :string
    add_column :fm_suppliers, :supplier_name, :string
    add_column :fm_suppliers, :lot_data, :jsonb, default: {}
    add_index :fm_suppliers, :contact_email
  end
end
