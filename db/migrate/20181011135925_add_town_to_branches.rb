class AddTownToBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :town, :text
  end
end
