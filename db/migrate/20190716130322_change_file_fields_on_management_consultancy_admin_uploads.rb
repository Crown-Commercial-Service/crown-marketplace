class ChangeFileFieldsOnManagementConsultancyAdminUploads < ActiveRecord::Migration[5.2]
  def change
    remove_column :management_consultancy_admin_uploads, :suppliers, :string
    remove_column :management_consultancy_admin_uploads, :supplier_service_offerings, :string
    remove_column :management_consultancy_admin_uploads, :supplier_regional_offerings, :string
    remove_column :management_consultancy_admin_uploads, :rate_cards, :string
    add_column :management_consultancy_admin_uploads, :suppliers_data, :string
  end
end
