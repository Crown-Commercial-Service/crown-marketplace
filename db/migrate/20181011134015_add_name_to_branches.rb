class AddNameToBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :name, :text
  end
end
