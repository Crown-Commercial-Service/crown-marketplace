class AddLocalGovernmentPensionScheme < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :local_government_pension_scheme, :boolean
  end
end
