class AddLocationToBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :location, :st_point, geographic: true, null: true
  end
end
