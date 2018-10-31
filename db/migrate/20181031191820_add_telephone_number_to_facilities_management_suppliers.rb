class AddTelephoneNumberToFacilitiesManagementSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_suppliers, :telephone_number, :text
  end
end
