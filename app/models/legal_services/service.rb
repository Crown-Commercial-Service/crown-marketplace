module LegalServices
  class Service
    include StaticRecord

    attr_accessor :code, :name, :lot_number

    def self.all_codes
      all.map(&:code)
    end

    def self.services_for_lot(lot)
      return where(lot_number: '2a') if lot == '2'

      where(lot_number: lot)
    end
  end

  Service.load_csv('legal_services/services.csv')
end
