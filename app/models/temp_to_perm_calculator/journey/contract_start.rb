module TempToPermCalculator
  class Journey::ContractStart
    include ::Journey::Step

    attribute :contract_start_day
    validates :contract_start_day,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
    attribute :contract_start_month
    validates :contract_start_month,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
    attribute :contract_start_year
    validates :contract_start_year,
              presence: true,
              numericality: { only_integer: true }

    attribute :hire_date_day
    validates :hire_date_day,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
    attribute :hire_date_month
    validates :hire_date_month,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }

    attribute :hire_date_year
    validates :hire_date_year,
              presence: true,
              numericality: { only_integer: true }

    def next_step_class
      Journey::DaysPerWeek
    end
  end
end
