module FacilitiesManagement
  module Steps
    class SupplierRegion
      include JourneyStep

      attribute :region_codes, Array
      validates :region_codes, length: { minimum: 1 }

      def initialize(*)
        self.region_codes = []
        super
      end

      def regions
        Region.where(code: region_codes)
      end

      def next_step_class
        Suppliers
      end
    end
  end
end
