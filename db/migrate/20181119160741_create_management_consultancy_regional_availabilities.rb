class CreateManagementConsultancyRegionalAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :management_consultancy_regional_availabilities, id: :uuid do |t|
      t.references :management_consultancy_supplier,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_mc_regional_availabilities_on_mc_supplier_id' }
      t.text :lot_number, null: false
      t.text :region_code, null: false
      t.timestamps
    end
  end
end
