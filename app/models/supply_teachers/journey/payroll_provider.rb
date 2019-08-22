module SupplyTeachers
  class Journey::PayrollProvider
    include Steppable

    attribute :payroll_provider
    validates :payroll_provider, inclusion: ['school', 'agency']

    def next_step_class
      case payroll_provider
      when 'school'
        Journey::FTACalculatorContractStart
      when 'agency'
        Journey::AgencyPayroll
      end
    end
  end
end
