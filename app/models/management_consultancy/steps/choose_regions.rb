module ManagementConsultancy
  module Steps
    class ChooseRegions
      include JourneyStep

      attribute :region_codes, Array
      validates :region_codes, length: { minimum: 1 }

      def regions
        Nuts2Region.where(code: region_codes)
      end

      def next_step_class
        Suppliers
      end
    end
  end
end
