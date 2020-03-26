class DeleteQuickSearchNameFromProcurementsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities_management_procurements, :name, :string
    remove_column :facilities_management_procurements, :date_offer_sent, :datetime
    remove_column :facilities_management_procurements, :contract_start_date, :date
    remove_column :facilities_management_procurements, :closed_contract_date, :date
    remove_column :facilities_management_procurements, :is_contract_closed, :boolean
  end
end
