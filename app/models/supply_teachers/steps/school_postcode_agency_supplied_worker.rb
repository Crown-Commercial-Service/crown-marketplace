module SupplyTeachers
  module Steps
    class SchoolPostcodeAgencySuppliedWorker
      include JourneyStep
      include Geolocatable

      attribute :postcode
      validates :location, location: true

      def next_step_class
        FixedTermResults
      end
    end
  end
end
