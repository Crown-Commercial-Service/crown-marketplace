class AddTermToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :term, :text
  end
end
