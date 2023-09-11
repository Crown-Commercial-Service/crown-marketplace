class MigrateDataFromJsonToColumns < ActiveRecord::Migration[5.2]
  class FMSupplier < ApplicationRecord
    self.table_name = 'fm_suppliers'
  end

  # rubocop:disable Metrics/AbcSize
  def up
    FMSupplier.find_each do |supplier|
      data = supplier.data
      supplier.contact_name = data['contact_name']
      supplier.contact_email = data['contact_email']
      supplier.contact_phone = data['contact_phone']
      supplier.supplier_name = data['supplier_name']

      ['1a', '1b', '1c'].each do |lot_number|
        lot_data = data['lots'].find { |lot| lot['lot_number'] == lot_number }
        supplier.lot_data[lot_number] = { regions: lot_data['regions'], services: lot_data['services'] } if lot_data
      end

      supplier.save
    end

    remove_column :fm_suppliers, :data
  end

  def down
    add_column :fm_suppliers, :data, :jsonb
    add_index :fm_suppliers, "((data -> 'lots'::text))", name: 'idxginlots', using: :gin
    add_index :fm_suppliers, ['data'], name: 'idxgin', using: :gin
    add_index :fm_suppliers, ['data'], name: 'idxginp', opclass: :jsonb_path_ops, using: :gin

    FMSupplier.find_each do |supplier|
      data = {}
      data['supplier_id'] = supplier.supplier_id
      data['contact_name'] = supplier.contact_name
      data['contact_email'] = supplier.contact_email
      data['contact_phone'] = supplier.contact_phone
      data['supplier_name'] = supplier.supplier_name
      data['lots'] = []

      ['1a', '1b', '1c'].each do |lot_number|
        data['lots'] << { lot_number: lot_number, regions: supplier.lot_data[lot_number]['regions'], services: supplier.lot_data[lot_number]['services'] } if supplier.lot_data[lot_number].present?
      end

      supplier.data = data
      supplier.save
    end
  end
  # rubocop:enable Metrics/AbcSize
end
