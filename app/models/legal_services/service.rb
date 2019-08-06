module LegalServices
  class Service
    include StaticRecord

    attr_accessor :code, :name, :lot_number

    def self.all_codes
      all.map(&:code)
    end
  end

  Service.load_csv('legal_services/services.csv')
end
