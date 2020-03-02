module FacilitiesManagement
  class SupplierDetail < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :supplier_detail, optional: true

    def full_organisation_address
      [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county, organisation_address_postcode].reject(&:nil?).reject(&:empty?).join(', ')
    end
  end
end
