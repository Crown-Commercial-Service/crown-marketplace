module SupplyTeachers
  class Journey::AgencyPayroll
    include Steppable
    include Geolocatable

    attribute :term
    validates :term, presence: true

    attribute :job_type
    validates :job_type, presence: true

    def next_step_class
      Journey::AgencyPayrollResults
    end
  end
end
