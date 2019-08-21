module SupplyTeachers
  class Journey::FTACalculatorSalary
    include Steppable

    attribute :salary
    validates :salary, presence: true
    validate :valid_salary

    def next_step_class
      Journey::SchoolPostcodeAgencySuppliedWorker
    end

    private

    def valid_salary
      errors.add(:salary, :invalid) if salary.to_f <= 0
    end
  end
end
