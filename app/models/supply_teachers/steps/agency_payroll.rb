module SupplyTeachers
  module Steps
    class AgencyPayroll
      include JourneyStep
      include Geolocatable

      attribute :term
      validates :term, presence: true

      attribute :job_type
      validates :job_type, presence: true

      def next_step_class
        AgencyPayrollResults
      end
    end
  end
end
