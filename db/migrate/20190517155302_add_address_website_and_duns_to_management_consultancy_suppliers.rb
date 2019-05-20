class AddAddressWebsiteAndDunsToManagementConsultancySuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :management_consultancy_suppliers, :address, :string
    add_column :management_consultancy_suppliers, :website, :string
    add_column :management_consultancy_suppliers, :duns, :integer, unique: true
  end
end
