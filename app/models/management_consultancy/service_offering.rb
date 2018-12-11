module ManagementConsultancy
  class ServiceOffering < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :management_consultancy_supplier_id,
               inverse_of: :service_offerings

    validates :lot_number, presence: true,
                           uniqueness: { scope: %i[supplier service_code] },
                           inclusion: { in: Lot.all_numbers }

    validates :service_code, presence: true,
                             uniqueness: { scope: %i[supplier lot_number] },
                             inclusion: { in: Service.all_codes }

    def self.for_lot(lot_number)
      where(lot_number: lot_number)
    end

    def self.for_service_code(service_code)
      where(service_code: service_code)
    end

    def service
      Service.find_by(code: service_code)
    end

    def self.supplier_ids_for_service_codes(service_codes)
      for_service_code(service_codes)
        .group(:management_consultancy_supplier_id)
        .having("COUNT(service_code) = #{service_codes.count}")
        .pluck(:management_consultancy_supplier_id)
    end
  end
end
