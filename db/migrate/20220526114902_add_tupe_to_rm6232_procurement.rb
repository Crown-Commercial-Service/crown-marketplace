class AddTupeToRM6232Procurement < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities_management_rm6232_procurements, :tupe, :boolean
  end
end
