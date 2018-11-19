module SupplyTeachers
  module Steps
    class AgencyPayrollResults
      include JourneyStep
      include Results

      attribute :job_type
      attribute :term

      def rates
        Rate.direct_provision.rate_for(job_type: job_type, term: term)
      end

      def rate(branch)
        branch.supplier.rate_for(job_type: job_type, term: term)
      end

      def job_type
        JobType.find_by(code: @job_type)
      end

      def term
        Term.find_by(code: @term)
      end

      def inputs
        {
          looking_for: translate_input('supply_teachers.looking_for.worker'),
          worker_type: translate_input('supply_teachers.worker_type.agency_supplied'),
          payroll_provider: translate_input('supply_teachers.payroll_provider.agency'),
          postcode: postcode,
          job_type: job_type.description,
          term: term.description,
        }
      end
    end
  end
end
