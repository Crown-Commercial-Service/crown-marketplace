class AddRateCardsToLegalServicesSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :legal_services_suppliers, :rate_cards, :jsonb
    add_index :legal_services_suppliers, :rate_cards, using: :gin
  end
end
