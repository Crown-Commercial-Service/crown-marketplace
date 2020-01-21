class AddDateOfferSentToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :date_offer_sent, :timestamp
  end
end
