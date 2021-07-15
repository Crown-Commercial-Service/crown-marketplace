module FacilitiesManagement
  module RM3830
    class Journey::ChooseServices
      include Steppable

      attribute :service_codes, Array
      attribute :region_codes, Array
      validates :service_codes, length: { minimum: 1 }

      def services
        StaticData.services
      end

      def work_packages
        StaticData.work_packages
      end

      def next_step_class
        Journey::ChooseLocations
      end
    end
  end
end
