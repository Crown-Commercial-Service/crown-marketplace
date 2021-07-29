module FacilitiesManagement
  module RM6232
    class Journey::ChooseLocations
      include Steppable

      attribute :region_codes, Array
      attribute :sector_code, String
      attribute :contract_cost, Numeric

      validates :region_codes, length: { minimum: 1 }

      def regions
        FacilitiesManagement::Region.where(code: region_codes)
      end

      def next_step_class
        Journey::ChooseSector
      end
    end
  end
end
