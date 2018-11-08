module SupplyTeachers
  module Steps
    class SchoolPostcode
      include JourneyStep
      include Geolocatable

      attribute :worker_type
      attribute :postcode
      validates :location, location: true

      def next_step_class
        if worker_type == 'nominated'
          NominatedWorkerResults
        else
          FixedTermResults
        end
      end
    end
  end
end
