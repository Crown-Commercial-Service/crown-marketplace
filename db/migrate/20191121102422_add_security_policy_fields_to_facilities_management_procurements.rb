class AddSecurityPolicyFieldsToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :security_policy_document_required, :boolean
    add_column :facilities_management_procurements, :security_policy_document_name, :string
    add_column :facilities_management_procurements, :security_policy_document_version_number, :string
    add_column :facilities_management_procurements, :security_policy_document_date, :date
    add_column :facilities_management_procurements, :security_policy_document_file, :string
  end
end
