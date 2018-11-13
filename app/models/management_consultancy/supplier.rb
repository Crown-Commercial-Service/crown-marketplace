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
        .uniq
    end
  end
end
