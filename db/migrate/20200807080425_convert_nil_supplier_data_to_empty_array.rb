class ConvertNilSupplierDataToEmptyArray < ActiveRecord::Migration[5.2]
  def self.up
    CCS::FM::Supplier.all.each do |supplier|
      supplier.data['lots'].each do |lot|
        lot['services'] = [] if lot['services'].nil?
      end
      supplier.save
    end
  end

  def self.down; end
end
