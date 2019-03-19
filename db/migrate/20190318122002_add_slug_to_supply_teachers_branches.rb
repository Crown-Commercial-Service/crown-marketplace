class AddSlugToSupplyTeachersBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :supply_teachers_branches, :slug, :string
    add_index :supply_teachers_branches, :slug, unique: true
  end
end
