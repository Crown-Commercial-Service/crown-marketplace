class AddAdditionalReasonForClosingContract < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_suppliers, :reason_for_declining, :text
    add_column :facilities_management_procurement_suppliers, :reason_for_not_signing, :text
  end
end
