class AddMobilisationAndExtendBooleans < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :mobilisation_period_required, :boolean
    add_column :facilities_management_procurements, :extensions_required, :boolean
  end
end
