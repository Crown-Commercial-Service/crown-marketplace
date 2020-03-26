module FacilitiesManagement
  class SupplierDetail < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :supplier_detail, optional: true

    def full_organisation_address
      [address_line_1, address_line_2, address_town, address_county, address_postcode].reject(&:nil?).reject(&:empty?).join(', ')
    end
  end
end
