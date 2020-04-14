class AddLotNumberSelectedByCustomerToProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :lot_number_selected_by_customer, :boolean, default: false
  end
end
