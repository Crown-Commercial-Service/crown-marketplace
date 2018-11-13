module ManagementConsultancy
  class ServiceOffering < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :management_consultancy_supplier_id,
               inverse_of: :service_offerings

    validates :lot_number, presence: true
    validates :service_code, presence: true

    def self.for_lot(lot_number)
      where(lot_number: lot_number)
    end
  end
end
