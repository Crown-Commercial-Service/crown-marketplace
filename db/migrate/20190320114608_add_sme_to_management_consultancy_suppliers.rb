class AddSmeToManagementConsultancySuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :management_consultancy_suppliers, :sme, :boolean
  end
end
