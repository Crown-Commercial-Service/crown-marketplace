module SupplyTeachers
  module Steps
    class SchoolPostcodeNominatedWorker
      include JourneyStep
      include Geolocatable

      def next_step_class
        NominatedWorkerResults
      end
    end
  end
end
