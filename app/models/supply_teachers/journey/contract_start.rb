module SupplyTeachers
  class Journey::ContractStart
    include Steppable

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

    attribute :days_per_week
    validates :days_per_week,
              presence: true,
              numericality: { greater_than: 0, less_than_or_equal_to: 5 }

    attribute :day_rate
    validates :day_rate, presence: true, numericality: { only_integer: true, greater_than: 0 }

    attribute :markup_rate
    validates :markup_rate,
              presence: true,
              numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

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
      Journey::Fee
    end

    def contract_start_date
      Date.new(contract_start_year.to_i, contract_start_month.to_i, contract_start_day.to_i)
    rescue ArgumentError
      nil
    end

    def hire_date
      Date.new(hire_date_year.to_i, hire_date_month.to_i, hire_date_day.to_i)
    rescue ArgumentError
      nil
    end
  end
end
