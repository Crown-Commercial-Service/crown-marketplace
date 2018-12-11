module FacilitiesManagement
  class RegionalAvailability < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :facilities_management_supplier_id,
               inverse_of: :regional_availabilities

    validates :lot_number, presence: true,
                           uniqueness: { scope: %i[supplier region_code] },
                           inclusion: { in: Lot.all_numbers }

    validates :region_code, presence: true,
                            inclusion: { in: Region.all_codes }

    def self.for_lot(lot_number)
      where(lot_number: lot_number)
    end

    def self.for_lot_and_regions(lot_number, region_codes)
      where(lot_number: lot_number, region_code: region_codes)
    end

    def self.supplier_ids_for_lot_and_regions(lot_number, region_codes)
      for_lot_and_regions(lot_number, region_codes)
        .group(:facilities_management_supplier_id)
        .having("COUNT(region_code) = #{region_codes.count}")
        .pluck(:facilities_management_supplier_id)
    end
  end
end
