module Steps
  class SchoolPayroll < JourneyStep
    attribute :payroll_provider
    validates :payroll_provider,
              inclusion: {
                in: ['school', 'agency'],
                message: 'Please choose an option'
              }

    def next_step_class
      case payroll_provider
      when 'school'
        SchoolPostcode
      when 'agency'
        AgencyPayroll
      end
    end
  end
end
