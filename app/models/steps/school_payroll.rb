module Steps
  class SchoolPayroll < JourneyStep
    attribute :school_payroll
    validates :school_payroll, yes_no: true

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
