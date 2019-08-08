class CreateLegalServicesRegionalAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :legal_services_regional_availabilities, id: :uuid do |t|
      t.references :legal_services_supplier,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_ls_regional_availabilities_on_ls_supplier_id' }
      t.text :region_code, null: false
      t.timestamps
    end
  end
end
