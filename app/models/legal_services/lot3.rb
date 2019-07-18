module LegalServices
  class Lot3
    include StaticRecord

    attr_accessor :service, :s1, :s2, :s3, :s4, :s5, :s6, :s7, :s8

    def self.all_services
      all.map(&:service).map(&:to_s)
    end
  end

  Lot3.load_csv('legal_service/lots3.csv')
end
