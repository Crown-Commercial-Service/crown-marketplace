module Steps
  class SupplierRegion
    include JourneyStep

    attribute :region_codes, Array

    def initialize(*)
      self.region_codes = []
      super
    end

    def regions
      FacilitiesManagementRegion.where(code: region_codes)
    end

    def next_step_class
      Suppliers
    end
  end
end
