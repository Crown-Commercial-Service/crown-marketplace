module SupplyTeachers
  class Journey::FTACalculatorContractEnd < GenericJourney
    include Steppable

    attribute :contract_start_date_day
    attribute :contract_start_date_month
    attribute :contract_start_date_year
    attribute :contract_end_date_day
    attribute :contract_end_date_month
    attribute :contract_end_date_year
    validates :contract_end_date, presence: true
    validate :ensure_contract_end_date_valid
    validate :ensure_contract_end_date_after_contract_start_date

    PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

    def next_step_class
      Journey::FTACalculatorSalary
    end

    def all_keys_needed?
      true
    end

    private

    def contract_end_date
      Date.strptime(
        "#{contract_end_date_year}-#{contract_end_date_month}-#{contract_end_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      nil
    end

    def contract_start_date
      Date.strptime(
        "#{contract_start_date_year}-#{contract_start_date_month}-#{contract_start_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      nil
    end

    def ensure_contract_end_date_valid
      Date.strptime(
        "#{contract_end_date_year}-#{contract_end_date_month}-#{contract_end_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      errors.add(:contract_end_date, :invalid)
    end

    def ensure_contract_end_date_after_contract_start_date
      return if contract_end_date.blank? || contract_start_date.blank?
      return if contract_end_date >= contract_start_date

      errors.add(:contract_end_date, :after_contract_start_date)
    end
  end
end
