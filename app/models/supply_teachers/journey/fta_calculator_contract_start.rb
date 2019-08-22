module SupplyTeachers
  class Journey::FTACalculatorContractStart
    include Steppable

    attribute :contract_start_date_day
    attribute :contract_start_date_month
    attribute :contract_start_date_year
    validates :contract_start_date, presence: true
    validate :ensure_contract_start_date_valid

    PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

    def next_step_class
      Journey::FTACalculatorContractEnd
    end

    private

    def contract_start_date
      Date.strptime(
        "#{contract_start_date_year}-#{contract_start_date_month}-#{contract_start_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      nil
    end

    def ensure_contract_start_date_valid
      Date.strptime(
        "#{contract_start_date_year}-#{contract_start_date_month}-#{contract_start_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      errors.add(:contract_start_date, :invalid)
    end
  end
end
