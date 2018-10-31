class AddContactEmailToFacilitiesManagementSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_suppliers, :contact_email, :text
  end
end
