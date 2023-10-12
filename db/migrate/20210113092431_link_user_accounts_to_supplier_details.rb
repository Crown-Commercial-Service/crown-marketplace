class LinkUserAccountsToSupplierDetails < ActiveRecord::Migration[5.2]
  class SupplierDetail < ApplicationRecord
    self.table_name = 'facilities_management_supplier_details'
  end

  class SupplierUser < ApplicationRecord
    self.table_name = 'users'
  end

  def up
    SupplierDetail.reset_column_information

    SupplierDetail.find_each do |supplier_detail|
      next if supplier_detail.user_id.present?

      contact_email = supplier_detail.contact_email
      supplier_user = SupplierUser.find_by(email: contact_email)
      next unless supplier_user

      supplier_detail.user_id = supplier_user.id
      supplier_detail.save
    end
  end

  def down; end
end
