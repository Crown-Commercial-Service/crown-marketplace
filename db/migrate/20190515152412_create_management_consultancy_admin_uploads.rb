class CreateManagementConsultancyAdminUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :management_consultancy_admin_uploads, id: :uuid do |t|
      t.string :aasm_state, limit: 15
      t.string :suppliers, limit: 255
      t.string :supplier_service_offerings, limit: 255
      t.string :supplier_regional_offerings, limit: 255
      t.string :rate_cards, limit: 255
      t.text :fail_reason

      t.timestamps
    end
  end
end
