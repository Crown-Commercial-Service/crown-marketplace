class AddContactOptInForBuyerDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :facilities_management_buyer_details, :contact_opt_in, :boolean
  end
end
