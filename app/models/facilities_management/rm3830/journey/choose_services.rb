module FacilitiesManagement
  module RM3830
    class Journey::ChooseServices
      include Steppable

      attribute :service_codes, Array
      attribute :region_codes, Array
      validates :service_codes, length: { minimum: 1 }

      def services
        FacilitiesManagement::RM3830::StaticData.services
      end

      def work_packages
        FacilitiesManagement::RM3830::StaticData.work_packages
      end

      def next_step_class
        Journey::ChooseLocations
      end
    end
  end
end
