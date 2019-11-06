class AddUserRefToBuyer < ActiveRecord::Migration[5.2]
  def change
    add_reference :facilities_management_buyer, :user, index: true
  end
end
