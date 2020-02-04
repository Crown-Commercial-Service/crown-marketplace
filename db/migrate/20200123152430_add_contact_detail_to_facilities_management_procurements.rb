class AddContactDetailToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :using_buyer_detail_for_invoice_details, :boolean
    add_column :facilities_management_procurements, :using_buyer_detail_for_notices_detail, :boolean
    add_column :facilities_management_procurements, :using_buyer_detail_for_authorised_detail, :boolean
    add_reference :facilities_management_procurement_contact_details, :facilities_management_procurement, type: :uuid, foreign_key: true, index: { name: 'index_fm_procurement_contact_details_on_fm_procurement_id' }
  end
end
