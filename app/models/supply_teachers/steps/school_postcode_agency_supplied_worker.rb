module SupplyTeachers
  module Steps
    class SchoolPostcodeAgencySuppliedWorker
      include JourneyStep
      include Geolocatable

      def next_step_class
        FixedTermResults
      end
    end
  end
end
