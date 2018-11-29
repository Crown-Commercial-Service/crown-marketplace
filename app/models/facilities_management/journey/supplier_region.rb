module FacilitiesManagement
  class Journey::SupplierRegion
    include JourneyStep

    attribute :region_codes, Array
    validates :region_codes, length: { minimum: 1 }

    def regions
      Region.where(code: region_codes)
    end

    def next_step_class
      Journey::Suppliers
    end
  end
end
