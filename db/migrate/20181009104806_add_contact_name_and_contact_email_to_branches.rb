class AddContactNameAndContactEmailToBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :contact_name, :text
    add_column :branches, :contact_email, :text
  end
end
