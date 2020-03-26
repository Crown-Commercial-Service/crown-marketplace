class Changestatusnullonfacilitiesmanagement < ActiveRecord::Migration[5.2]
  def change
    change_column_null :facilities_management_buildings, :status, true
  end
end
