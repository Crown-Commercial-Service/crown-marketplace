module SupplyTeachers
  class Journey::SchoolPostcodeAgencySuppliedWorker
    include JourneyStep
    include Geolocatable

    def next_step_class
      Journey::FixedTermResults
    end
  end
end
