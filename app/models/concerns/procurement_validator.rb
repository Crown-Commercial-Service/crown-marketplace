module ProcurementValidator
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    # validations on :name step
    validates :name, presence: true, on: :name
    validates :name, uniqueness: { scope: :user }, on: :name
    validates :name, length: 1..100, on: :name

    # validations on :contract_name step
    validates :contract_name, presence: true, on: :contract_name
    validates :contract_name, uniqueness: { scope: :user }, on: :contract_name
    validates :contract_name, length: 1..100, on: :contract_name

    # validations on :estimated_annual_cost step
    validates :estimated_cost_known, inclusion: { in: [true, false] }, on: :estimated_annual_cost
    validates :estimated_annual_cost, presence: true, if: -> { estimated_cost_known? }, on: :estimated_annual_cost
    validates :estimated_annual_cost, numericality: { allow_nil: false, only_integer: true,
                                                      greater_than_or_equal_to: 1 },
                                      if: -> { estimated_cost_known? },
                                      on: :estimated_annual_cost
    # validations on :procurement_buildings step
    validate :at_least_one_active_procurement_building, on: :procurement_buildings

    validate :service_codes_not_empty, on: :services

    validates :tupe, inclusion: { in: [true, false] }, on: :tupe

    #############################################
    # Validation rules for contract-dates
    # these rules need to cover
    #   initial_call_off_period (int)
    #   initial_call_off_start_date (date)
    #   initial_call_off_end_date (date)
    #   mobilisation_period (int)
    #   extension_period (int)
    #   optional_call_off_extensions_1 (int)
    #   optional_call_off_extensions_2 (int)
    #   optional_call_off_extensions_3 (int)
    #   optional_call_off_extensions_4 (int)
    # they are prepared and layed-out in logical sequence
    # they are tested in the appropriate rspec
    validates :initial_call_off_period, presence: true, on: :contract_dates
    validates :initial_call_off_period, numericality: { allow_nil: false, only_integer: true,
                                                        greater_than_or_equal_to: 1 },
                                        if: -> { initial_call_off_period.present? }, on: :contract_dates
    validates :initial_call_off_period, numericality: { allow_nil: false, only_integer: true,
                                                        less_than_or_equal_to: 7 },
                                        if: -> { initial_call_off_period.present? }, on: :contract_dates
    validates :initial_call_off_start_date, presence: true,
                                            if: :initial_call_off_period_expects_a_date?,
                                            on: :contract_dates
    validates :initial_call_off_start_date, date: { allow_nil: false, after_or_equal_to: proc { Time.zone.today } },
                                            if: :initial_call_off_period_expects_a_date?,
                                            on: :contract_dates
    validates :mobilisation_period, numericality: { allow_nil: true, only_integer: true,
                                                    greater_than: -1 },
                                    if: -> { initial_call_off_period.present? ? initial_call_off_period.positive? : false },
                                    on: :contract_dates
    validates :mobilisation_period, numericality: { allow_nil: true, only_integer: true,
                                                    greater_than_or_equal_to: 4 },
                                    if: -> { tupe? && (initial_call_off_period.present? ? initial_call_off_period.positive? : false) },
                                    on: :contract_dates

    validates :optional_call_off_extensions_1, numericality: { allow_nil: true }, on: :contract_dates
    validates :optional_call_off_extensions_2, numericality: { allow_nil: true }, on: :contract_dates
    validates :optional_call_off_extensions_3, numericality: { allow_nil: true }, on: :contract_dates
    validates :optional_call_off_extensions_4, numericality: { allow_nil: true }, on: :contract_dates
    validate :optional_call_off_extensions_too_long, on: :contract_dates
    #
    # End of validation rules for contract-dates
    #############################################

    validates :security_policy_document_file, presence: true, if: :security_policy_document_required?, on: :security_policy_document
    validates :security_policy_document_date, date: { allow_nil: true }, on: :security_policy_document

    private

    #############################################
    # Start of validation methods for contract-dates
    def validate_contract_data?
      initial_call_off_period.present? ? initial_call_off_period.positive? : false
    end

    def initial_call_off_period_expects_a_date?
      return (1..7).include? initial_call_off_period if initial_call_off_period.present?

      false
    end

    def total_extensions
      optional_call_off_extensions_1.to_i + optional_call_off_extensions_2.to_i + optional_call_off_extensions_3.to_i + optional_call_off_extensions_4.to_i
    end

    def optional_call_off_extensions_too_long
      errors.add(:optional_call_off_extensions_1, :too_long) unless initial_call_off_period.to_i + total_extensions <= 10
    end
    # End of validation methods for contract-dates
    #############################################

    def at_least_one_active_procurement_building
      errors.add(:procurement_buildings, :invalid) unless procurement_buildings.map(&:active).any?(true)
    end

    def service_codes_not_empty
      errors.add(:service_codes, :invalid) if defined?(service_codes) && service_codes.empty?
    end
  end
  # rubocop:enable Metrics/BlockLength
end
