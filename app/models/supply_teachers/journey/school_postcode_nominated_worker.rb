module SupplyTeachers
  class Journey::SchoolPostcodeNominatedWorker
    include ::Journey::Step
    include Geolocatable

    def next_step_class
      Journey::NominatedWorkerResults
    end
  end
end
