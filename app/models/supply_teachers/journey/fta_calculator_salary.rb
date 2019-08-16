module SupplyTeachers
  class Journey::FTACalculatorSalary
    include Steppable

    attribute :salary
    validates :salary, presence: true

    def next_step_class
      Journey::SchoolPostcodeAgencySuppliedWorker
    end
  end
end
