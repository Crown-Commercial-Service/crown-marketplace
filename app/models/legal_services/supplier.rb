module LegalServices
  class Supplier < ApplicationRecord
    has_many :regional_availabilities,
             foreign_key: :legal_services_supplier_id,
             inverse_of: :supplier,
             dependent: :destroy

    has_many :service_offerings,
             foreign_key: :legal_services_supplier_id,
             inverse_of: :supplier,
             dependent: :destroy

    has_many :rate_cards,
             foreign_key: :legal_services_supplier_id,
             inverse_of: :supplier,
             dependent: :destroy

    validates :name, presence: true

    def self.available_in_lot(lot_number)
      joins(:service_offerings)
        .merge(ServiceOffering.for_lot(lot_number))
        .includes(:service_offerings)
        .uniq
    end

    def self.offering_services(lot_number, service_codes)
      lot_service_codes = Service.where(lot_number: lot_number).map(&:code)
      valid_service_codes = service_codes & lot_service_codes
      ids = ServiceOffering.supplier_ids_for_service_codes(valid_service_codes)
      where(id: ids)
    end

    def self.supplying_regions(region_codes)
      ids = RegionalAvailability.supplier_ids_for_region_codes(region_codes)
      where(id: ids)
    end

    def self.offering_services_in_regions(lot_number, service_codes, region_codes = nil)
      return offering_services(lot_number, service_codes) unless lot_number == '1'

      offering_services(lot_number, service_codes).supplying_regions(region_codes)
    end

    def self.delete_all_with_dependents
      RegionalAvailability.delete_all
      ServiceOffering.delete_all
      delete_all
    end

    def services_in_lot(lot_number)
      service_offerings.select { |so| so.lot_number == lot_number }.map(&:service)
    end
  end
end
