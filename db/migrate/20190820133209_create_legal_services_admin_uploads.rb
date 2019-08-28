class CreateLegalServicesAdminUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :legal_services_admin_uploads, id: :uuid do |t|
      t.string  :aasm_state, limit: 15
      t.string  :suppliers, limit: 255
      t.string  :supplier_lot_1_service_offerings, limit: 255
      t.string  :supplier_lot_2_service_offerings, limit: 255
      t.string  :supplier_lot_3_service_offerings, limit: 255
      t.string  :supplier_lot_4_service_offerings, limit: 255
      t.string  :rate_cards, limit: 255
      t.jsonb   :data
      t.text    :fail_reason

      t.timestamps
    end
  end
end
