module LegalServices
  class Subservice
    include StaticRecord

    attr_accessor :code, :name, :service

    def self.all_codes
      all.map(&:code)
    end
  end

  Subservice.load_csv('legal_services/subservices.csv')
end
