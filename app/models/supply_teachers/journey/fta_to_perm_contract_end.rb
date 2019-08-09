module SupplyTeachers
  class Journey::FTAToPermContractEnd < GenericJourney
    include Steppable

    attribute :contract_start_date_day
    attribute :contract_start_date_month
    attribute :contract_start_date_year
    attribute :contract_end_date_day
    attribute :contract_end_date_month
    attribute :contract_end_date_year
    validate :ensure_contract_end_date_valid
    validate :ensure_contract_end_date_after_contract_start_date
    validates :contract_end_date, presence: true

    PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

    def next_step_class
      if contract_end_date && contract_end_within_6_months && contract_length_within_12_months
        Journey::FTAToPermHireDate
      else
        #no fee
        Journey::FTAToPermFee
      end
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

    def contract_end_within_6_months
      today = Date.today
      ((today.year * 12 + today.month) - (contract_end_date_year.to_i * 12 + contract_end_date_month.to_i)) <= 6
    end

    def contract_length_within_12_months
      ((contract_end_date_year.to_i * 12 + contract_end_date_month.to_i) - (contract_start_date_year.to_i * 12 + contract_start_date_month.to_i)) < 12
    end
  end
end
