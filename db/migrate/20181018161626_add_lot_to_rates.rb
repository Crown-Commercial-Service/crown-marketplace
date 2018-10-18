class AddLotToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :lot_number, :integer, null: false, default: 1
  end
end
