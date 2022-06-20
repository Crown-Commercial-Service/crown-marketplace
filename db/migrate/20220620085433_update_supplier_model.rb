class UpdateSupplierModel < ActiveRecord::Migration[6.0]
  def change
    remove_column :facilities_management_rm6232_suppliers, :contact_name, :string, limit: 255
    remove_column :facilities_management_rm6232_suppliers, :contact_email, :string, limit: 255
    remove_column :facilities_management_rm6232_suppliers, :contact_phone, :string, limit: 255
  end
end
