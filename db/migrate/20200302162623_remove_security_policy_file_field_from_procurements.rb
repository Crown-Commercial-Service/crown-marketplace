class RemoveSecurityPolicyFileFieldFromProcurements < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities_management_procurements, :security_policy_document_file, :string
  end
end
