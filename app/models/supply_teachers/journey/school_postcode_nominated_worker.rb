module SupplyTeachers
  class Journey::SchoolPostcodeNominatedWorker
    include JourneyStep
    include Geolocatable

    def next_step_class
      Journey::NominatedWorkerResults
    end
  end
end
