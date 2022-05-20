class AddContractNumberRow < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities_management_rm6232_procurements, :contract_number, :string
  end
end
