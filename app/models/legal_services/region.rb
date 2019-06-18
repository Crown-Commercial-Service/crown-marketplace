module LegalServices
  class Regions
    include StaticRecord

    attr_accessor :firm, :region, :property_and_construction, :social_housing, :child_law, :court_of_protection, :education, :debt_recovery, :planning_and_environment, :licensing, :pensions, :litigation_and_dispute_resolution, :intellectual_property, :employment, :health_care, :primary_care
    
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

  Region.load_csv('legal_service/regions.csv')
end
