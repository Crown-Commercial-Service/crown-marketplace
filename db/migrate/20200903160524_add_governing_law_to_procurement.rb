class AddGoverningLawToProcurement < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :governing_law, :string
  end
end
