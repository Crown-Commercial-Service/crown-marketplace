class AddColumnsToFmSupplier < ActiveRecord::Migration[5.2]
  def change
    add_reference :fm_suppliers, :user, foreign_key: true, type: :uuid
    add_column :fm_suppliers, :sme, :boolean
    add_column :fm_suppliers, :duns, :string, limit: 255
    add_column :fm_suppliers, :registration_number, :string, limit: 255
    add_column :fm_suppliers, :address_line_1, :string, limit: 255
    add_column :fm_suppliers, :address_line_2, :string, limit: 255
    add_column :fm_suppliers, :address_town, :string, limit: 255
    add_column :fm_suppliers, :address_county, :string, limit: 255
    add_column :fm_suppliers, :address_postcode, :string, limit: 255
  end
end
