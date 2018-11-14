class AddContactFieldsToManagementConsultancySuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :management_consultancy_suppliers, :contact_name, :text
    add_column :management_consultancy_suppliers, :contact_email, :text
    add_column :management_consultancy_suppliers, :telephone_number, :text
  end
end
