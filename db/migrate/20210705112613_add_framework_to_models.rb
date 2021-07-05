class AddFrameworkToModels < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities_management_procurements, :framework, :string, limit: 6
    add_index :facilities_management_procurements, :framework
  end
end
