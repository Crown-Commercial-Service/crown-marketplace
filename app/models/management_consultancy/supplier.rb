module ManagementConsultancy
  class Supplier < ApplicationRecord
    has_many :service_offerings,
             foreign_key: :management_consultancy_supplier_id,
             inverse_of: :supplier,
             dependent: :destroy

    validates :name, presence: true

    def self.available_in_lot(lot_number)
      joins(:service_offerings)
        .merge(ServiceOffering.for_lot(lot_number))
        .includes(:service_offerings)
        .uniq
    end

    def services_in_lot(lot_number)
      service_offerings.select { |so| so.lot_number == lot_number }.map(&:service)
    end
  end
end
