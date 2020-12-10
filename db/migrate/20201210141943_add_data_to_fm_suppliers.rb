class AddDataToFmSuppliers < ActiveRecord::Migration[5.2]
  class SupplierDetail < ApplicationRecord
    self.table_name = 'facilities_management_supplier_details'
  end

  class FMSupplier < ApplicationRecord
    self.table_name = 'fm_suppliers'
  end

  def up
    SupplierDetail.all.each do |supplier_detail|
      contact_email = supplier_detail.contact_email
      fm_supplier = FMSupplier.find_by(contact_email: contact_email)
      next if fm_supplier.blank?

      fm_supplier.update(
        user_id: supplier_detail.user_id,
        sme: supplier_detail.sme,
        duns: supplier_detail.duns,
        registration_number: supplier_detail.registration_number,
        address_line_1: supplier_detail.address_line_1,
        address_line_2: supplier_detail.address_line_2,
        address_town: supplier_detail.address_town,
        address_county: supplier_detail.address_county,
        address_postcode: supplier_detail.address_postcode
      )
    end
  end

  def down; end
end
