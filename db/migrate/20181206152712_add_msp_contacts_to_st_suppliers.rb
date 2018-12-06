class AddMspContactsToStSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :supply_teachers_suppliers, :neutral_vendor_contact_name, :text
    add_column :supply_teachers_suppliers, :neutral_vendor_telephone_number, :text
    add_column :supply_teachers_suppliers, :neutral_vendor_contact_email, :text

    add_column :supply_teachers_suppliers, :master_vendor_contact_name, :text
    add_column :supply_teachers_suppliers, :master_vendor_telephone_number, :text
    add_column :supply_teachers_suppliers, :master_vendor_contact_email, :text
  end
end
