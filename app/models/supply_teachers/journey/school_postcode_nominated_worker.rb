module SupplyTeachers
  class Journey::SchoolPostcodeNominatedWorker
    include Steppable
    include Geolocatable

    def next_step_class
      Journey::NominatedWorkerResults
    end
  end
end
