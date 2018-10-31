class AddContactNameToFacilitiesManagementSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_suppliers, :contact_name, :text
  end
end
