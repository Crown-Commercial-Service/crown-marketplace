module TempToPermCalculator
  class Journey::ContractStart
    include JourneyStep

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

    def next_step_class
      Journey::HireDate
    end
  end
end
