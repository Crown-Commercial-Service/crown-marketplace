module Steps
  class SchoolPayroll < JourneyStep
    attribute :school_payroll
    validates :school_payroll, inclusion: { in: %w[yes no] }

    def next_step_class
      case school_payroll
      when 'yes'
        SchoolPostcode
      when 'no'
        AgencyPayroll
      end
    end
  end
end
