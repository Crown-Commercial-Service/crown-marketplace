class AddPaymentMethodsToFaciilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :bacs_payment, :string
    add_column :facilities_management_procurements, :government_procurement_card, :string
  end
end
