module SupplyTeachers
  module Steps
    class SchoolPostcodeNominatedWorker
      include JourneyStep
      include Geolocatable

      attribute :postcode
      validates :location, location: true

      def next_step_class
        NominatedWorkerResults
      end
    end
  end
end
