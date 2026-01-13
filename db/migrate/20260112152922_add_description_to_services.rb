class AddDescriptionToServices < ActiveRecord::Migration[8.1]
  def change
    add_column :services, :description, :text
  end
end
