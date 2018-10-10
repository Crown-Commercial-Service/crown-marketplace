class AddTelephoneNumberToBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :telephone_number, :text
  end
end
