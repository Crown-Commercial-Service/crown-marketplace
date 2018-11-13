class AddSupplyTeachersPrefixes < ActiveRecord::Migration[5.2]
  def up
    rename_table :branches, :supply_teachers_branches
    rename_column :supply_teachers_branches, :supplier_id, :supply_teachers_supplier_id
    rename_table :rates, :supply_teachers_rates
    rename_column :supply_teachers_rates, :supplier_id, :supply_teachers_supplier_id
    rename_table :suppliers, :supply_teachers_suppliers
  end

  def down
    rename_table :supply_teachers_suppliers, :suppliers
    rename_column :supply_teachers_rates, :supply_teachers_supplier_id, :supplier_id
    rename_table :supply_teachers_rates, :rates
    rename_column :supply_teachers_branches, :supply_teachers_supplier_id, :supplier_id
    rename_table :supply_teachers_branches, :branches
  end
end
