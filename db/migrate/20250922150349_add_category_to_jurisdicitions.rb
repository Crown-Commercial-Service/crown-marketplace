class AddCategoryToJurisdicitions < ActiveRecord::Migration[8.0]
  def change
    add_column :jurisdictions, :category, :text
  end
end
