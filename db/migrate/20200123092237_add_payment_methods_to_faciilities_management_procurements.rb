class AddPaymentMethodsToFaciilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :payment_method, :string, null: false
  end
end
