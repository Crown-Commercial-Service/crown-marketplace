module SupplyTeachers
  class Journey::FTAToPermHireDate
    include Steppable
    include Dateable

    attribute :contract_end_date_day
    attribute :contract_end_date_year
    attribute :contract_end_date_month
    attribute :hire_date_day
    attribute :hire_date_month
    attribute :hire_date_year
    attribute :no_fee_reason
    validates :hire_date, presence: true
    validate :ensure_hire_date_valid
    validate :ensure_hire_date_after_contract_start_date

    PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

    def next_step_class
      if hire_date && hire_date_within_6_months_of_contract_end
        Journey::FTAToPermHireDateNotice
      else
        @no_fee_reason = 'hire_not_within_6_months'
        Journey::FTAToPermFee
      end
    end

    def all_keys_needed?
      true
    end

    def hire_by_date
      contract_end_date + 6.months
    end

    private

    def hire_date
      Date.strptime(
        "#{hire_date_year}-#{hire_date_month}-#{hire_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      nil
    end

    def contract_end_date
      Date.strptime(
        "#{contract_end_date_year}-#{contract_end_date_month}-#{contract_end_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      nil
    end

    def ensure_hire_date_valid
      Date.strptime(
        "#{hire_date_year}-#{hire_date_month}-#{hire_date_day}",
        PARSED_DATE_FORMAT
      )
    rescue ArgumentError
      errors.add(:hire_date, :invalid)
    end

    def ensure_hire_date_after_contract_start_date
      return if hire_date.blank? || contract_end_date.blank?
      return if hire_date >= contract_end_date

      errors.add(:hire_date, :after_contract_end_date)
    end

    def hire_date_within_6_months_of_contract_end
      return unless hire_date && contract_end_date

      difference_in_months(contract_end_date, hire_date) < 6
    end
  end
end
