class ConvertNilSupplierDataToEmptyArray < ActiveRecord::Migration[5.2]
  class FMSupplier < ApplicationRecord
    self.table_name = 'fm_suppliers'
  end

  def self.up
    FMSupplier.find_each do |supplier|
      supplier.data['lots'].each do |lot|
        lot['services'] = [] if lot['services'].nil?
      end
      supplier.save
    end
  end

  def self.down; end
end
