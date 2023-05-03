class AddSectorForBuyerDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :facilities_management_buyer_details, :sector, :string, limit: 255
  end
end
