module ManagementConsultancy
  class RegionalAvailability < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :management_consultancy_supplier_id,
               inverse_of: :regional_availabilities

    validates :lot_number, presence: true
    validates :region_code, presence: true

    def self.for_lot_and_regions(lot_number, region_codes)
      where(lot_number: lot_number, region_code: region_codes)
    end

    def self.supplier_ids_for_region_codes(lot_number, region_codes)
      for_lot_and_regions(lot_number, region_codes)
        .group(:management_consultancy_supplier_id)
        .having("COUNT(region_code) = #{region_codes.count}")
        .pluck(:management_consultancy_supplier_id)
    end
  end
end
