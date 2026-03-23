module FacilitiesManagement
  module RM3830
    class Journey::ChooseServices
      include Steppable

      attribute :service_codes, :array, default: -> { [] }
      attribute :region_codes, :array, default: -> { [] }
      validates :service_codes, length: { minimum: 1 }

      def services
        @services ||= StaticData.services
      end

      def work_packages
        @work_packages ||= StaticData.work_packages
      end

      def next_step_class
        Journey::ChooseLocations
      end
    end
  end
end
