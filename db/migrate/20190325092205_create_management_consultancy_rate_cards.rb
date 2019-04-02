class CreateManagementConsultancyRateCards < ActiveRecord::Migration[5.2]
  # indexes were given explicit names as there is a 63 character limit
  def change
    create_table :management_consultancy_rate_cards, id: :uuid do |t|
      t.references :management_consultancy_supplier,
                   foreign_key: true, type: :uuid, null: false, index: { name: :index_management_consultancy_rate_cards_on_supplier_id }
      t.integer   :lot
      t.integer   :junior_rate_in_pence
      t.integer   :standard_rate_in_pence
      t.integer   :senior_rate_in_pence
      t.integer   :principal_rate_in_pence
      t.integer   :managing_rate_in_pence
      t.integer   :director_rate_in_pence
      t.timestamps
    end
  end
end
