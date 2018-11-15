module SupplyTeachers
  module Steps
    class PayrollProvider
      include JourneyStep

      attribute :payroll_provider
      validates :payroll_provider, inclusion: ['school', 'agency']

      def next_step_class
        case payroll_provider
        when 'school'
          SchoolPostcodeAgencySuppliedWorker
        when 'agency'
          AgencyPayroll
        end
      end
    end
  end
end
