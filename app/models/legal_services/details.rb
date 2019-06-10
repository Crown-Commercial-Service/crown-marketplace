module LegalServices
  class Details
    include StaticRecord

    attr_accessor :firm, :email, :phone, :address, :sme, :DUNS_number, :lot1_prospectus, :lot2_prospectus, :lo3_propsectus, :lot4_prospectuss, :about

    def self.for_region(region, child_law, court_of_protection)
      where(region: region, child_law: child_law, court_of_protection: court_of_protection)
    end

    def self.for_service(service)
      case service
      when 'child_law'
        where(child_law: 'x')
      when 'court_of_protection'
        where(court_of_protection: 'x')
      end
    end

    def full_description
      "Lot #{firm} - #{description}"
    end

    def self.all_firms
      all.map(&:firm)
    end

    def self.all_regions
      all.map(&:region)
    end
  end

  Details.load_csv('legal_service/supplierdetails.csv')
end
