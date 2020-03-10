class AddContractSignedBoolToContract < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_suppliers, :contract_signed, :boolean
  end
end

