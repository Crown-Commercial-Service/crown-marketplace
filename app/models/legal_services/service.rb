module LegalServices
  class Service
    include StaticRecord

    attr_accessor :code, :name, :lot_number, :framework

    def self.all_codes
      all.map(&:code)
    end

    def subservices
      LegalServices::Subservice.where(service: code)
    end
  end

  Service.load_csv('legal_services/services.csv')
end
