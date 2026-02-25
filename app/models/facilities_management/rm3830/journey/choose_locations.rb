module FacilitiesManagement
  module RM3830
    class Journey::ChooseLocations
      include Steppable

      attribute :region_codes, :array, default: -> { [] }
      validates :region_codes, length: { minimum: 1 }

      def regions
        FacilitiesManagement::Region.where(code: region_codes)
      end

      def next_step_class
        Journey::Procurement
      end
    end
  end
end
