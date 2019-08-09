module SupplyTeachers
  class Journey::FTAToPermHireDate
    include Steppable

    attribute :contract_end_date_day
    attribute :contract_end_date_year
    attribute :contract_end_date_month
    attribute :hire_date_day
    attribute :hire_date_month
    attribute :hire_date_year
    validate :ensure_hire_date_valid
    validate :ensure_hire_date_after_contract_start_date
    validates :contract_end_date, presence: true

    PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

    def next_step_class
      if hire_date && hire_date_within_6_months_of_contract_end
        Journey::FTAToPermHireDateNotice
      else
        #no fee
        Journey::FTAToPermFee
      end
    end

    def all_keys_needed?
      true
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
      (hire_date_year.to_i * 12 + hire_date_month.to_i) - (contract_end_date_year.to_i * 12 + contract_end_date_month.to_i) < 6
    end
  end
end
