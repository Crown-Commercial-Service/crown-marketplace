class UpdateUserRefInBuyerDetails < ActiveRecord::Migration[5.2]
  def change
    # deleting all buyer details to make sure we get rid of inconsistencies
    FacilitiesManagement::BuyerDetail.destroy_all

    change_table :facilities_management_buyer_details do |t|
      # rubocop:disable Rails/ReversibleMigration
      t.remove :user_id
      # rubocop:enable Rails/ReversibleMigration

      # rubocop:disable Rails/NotNullColumn
      t.references :user, foreign_key: true, type: :uuid, null: false
      # rubocop:enable Rails/NotNullColumn
    end
  end
end
