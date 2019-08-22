module SupplyTeachers
  class Journey::FixedTermResults
    include Steppable
    include Dateable
    include Journey::Results
    include ActiveSupport::NumberHelper

    attribute :contract_start_date_day
    attribute :contract_start_date_month
    attribute :contract_start_date_year
    attribute :contract_end_date_day
    attribute :contract_end_date_month
    attribute :contract_end_date_year

    PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

    def rates
      Rate.direct_provision.fixed_term
    end

    def rate(branch)
      branch.supplier.fixed_term_rate
    end

    def fixed_term_length
      difference_in_months(contract_start_date, contract_end_date)
    end

    def inputs
      {
        looking_for: translate_input('supply_teachers.looking_for.worker'),
        worker_type: translate_input('supply_teachers.worker_type.agency_supplied'),
        payroll_provider: translate_input('supply_teachers.payroll_provider.school'),
        postcode: postcode,
        radius: number_to_human(radius, units: :miles)
      }
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
