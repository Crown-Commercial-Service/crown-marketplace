module LegalServices
  class RegionalAvailability < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :legal_services_supplier_id,
               inverse_of: :regional_availabilities

    validates :service_code,  presence: true,
                              uniqueness: { scope: %i[supplier region_code] },
                              inclusion: { in: Service.all_codes }

    validates :region_code, presence: true,
                            uniqueness: { scope: %i[supplier service_code] },
                            inclusion: { in: Nuts1Region.all_codes + ['UK'] }

    def self.supplier_ids_for_service_codes_and_region_codes(service_codes, region_codes)
      where(service_code: service_codes, region_code: region_codes)
        .group(:legal_services_supplier_id)
        .having("COUNT(DISTINCT(region_code))= #{region_codes.count}")
        .having("COUNT(DISTINCT(service_code))= #{service_codes.count}")
        .having("COUNT(region_code)= #{region_codes.count * service_codes.count}")
        .pluck(:legal_services_supplier_id)
    end
  end
end
