class ChangePensionPercentageFromIntegerToFloat < ActiveRecord::Migration[5.2]
  def up
    change_column :facilities_management_procurement_pension_funds, :percentage, :float
  end

  def down
    change_column :facilities_management_procurement_pension_funds, :percentage, :integer
  end
end
