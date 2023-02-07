class AddExpensesRequiredToMcra < ActiveRecord::Migration[5.2]
  def up
    add_column :management_consultancy_regional_availabilities, :expenses_required, :boolean
    execute <<~SQL.squish
      UPDATE management_consultancy_regional_availabilities
      SET expenses_required = false
    SQL
    change_column_null :management_consultancy_regional_availabilities, :expenses_required, false
  end

  def down
    remove_column :management_consultancy_regional_availabilities, :expenses_required
  end
end
