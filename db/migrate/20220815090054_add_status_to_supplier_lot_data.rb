class AddStatusToSupplierLotData < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities_management_rm6232_supplier_lot_data, :active, :boolean, default: true
  end
end
