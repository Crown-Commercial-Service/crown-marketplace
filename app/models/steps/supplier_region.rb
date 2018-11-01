module Steps
  class SupplierRegion < JourneyStep
    attribute :region_codes, Array

    # TODO: use attribute types instead. Virtus?
    def region_codes
      @region_codes || []
    end

    def regions
      FacilitiesManagementRegion.where(code: region_codes)
    end

    def next_step_class
      Suppliers
    end
  end
end
