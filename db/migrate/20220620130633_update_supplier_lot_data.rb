class UpdateSupplierLotData < ActiveRecord::Migration[6.0]
  def up
    change_column :facilities_management_rm6232_supplier_lot_data, :lot_code, :string, limit: 2
  end

  def down; end
end
