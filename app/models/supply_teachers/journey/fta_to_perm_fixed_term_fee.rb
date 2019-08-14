module SupplyTeachers
  class Journey::FTAToPermFixedTermFee
    include Steppable
    include Dateable

    attribute :fixed_term_fee
    attribute :contract_start_date_day
    attribute :contract_start_date_month
    attribute :contract_start_date_year
    attribute :contract_end_date_day
    attribute :contract_end_date_month
    attribute :contract_end_date_year
    validates :fixed_term_fee, presence: true

    PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

    def next_step_class
      Journey::FTAToPermFee
    end

    def all_keys_needed?
      true
    end

    def current_contract_length
      return unless contract_start_date && contract_end_date

      difference_in_months(contract_start_date, contract_end_date)
    end

    def hire_by_date
      contract_end_date + 6.months
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
  end
end
