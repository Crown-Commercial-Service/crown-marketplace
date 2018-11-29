module SupplyTeachers
  class Journey::SchoolPostcodeAgencySuppliedWorker
    include ::Journey::Step
    include Geolocatable

    def next_step_class
      Journey::FixedTermResults
    end
  end
end
