module LegalServices
  class RegionalAvailability < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :legal_services_supplier_id,
               inverse_of: :regional_availabilities

    validates :region_code, presence: true,
                            uniqueness: { scope: %i[supplier] },
                            inclusion: { in: Nuts1Region.all_codes }

    def self.supplier_ids_for_region_codes(region_codes)
      where(region_code: region_codes)
        .group(:legal_services_supplier_id)
        .having("COUNT(region_code) = #{region_codes.count}")
        .pluck(:legal_services_supplier_id)
    end
  end
end
