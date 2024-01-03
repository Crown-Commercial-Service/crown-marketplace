module FacilitiesManagement
  module ProcurementValidator
    extend ActiveSupport::Concern

    included do
      with_options on: :contract_name do
        before_validation :remove_excess_whitespace_from_name
        validates :contract_name, presence: true
        validates :contract_name, uniqueness: { scope: :user }
        validates :contract_name, length: 1..100
      end

      validates :tupe, inclusion: [true, false], on: :tupe

      with_options on: :contract_period do
        validates :initial_call_off_period_years, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7 }
        validates :initial_call_off_period_months, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 11 }
        validate :initial_call_off_period_length

        validate :initial_call_off_start_date_present, :initial_call_off_start_date_real
        validates :initial_call_off_start_date, date: { after_or_equal_to: proc { Time.zone.today }, before: proc { Time.new(2100).in_time_zone('London') } }

        validates :mobilisation_period_required, inclusion: { in: [true, false] }
        validates :mobilisation_period, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 52 }, if: -> { mobilisation_period_required }

        validates :mobilisation_period_required, inclusion: { in: [true], message: :not_valid_with_tupe }, if: -> { tupe }
        validates :mobilisation_period, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 4, less_than_or_equal_to: 52 }, if: -> { tupe && mobilisation_period_required }

        validate  :mobilisation_start_date_validation, if: -> { mobilisation_period_required && initial_call_off_start_date.present? && mobilisation_period.present? && mobilisation_period <= 52 }

        validates :extensions_required, inclusion: { in: [true, false] }

        after_validation :total_contract_length, :remove_empty_extensions
      end

      with_options on: :services do
        validates :service_codes, length: { minimum: 1 }
        validate :validate_not_all_mandatory
      end

      validate :at_least_one_active_procurement_building, on: :buildings
    end

    private

    def remove_excess_whitespace_from_name
      contract_name&.squish!
    end

    #############################################
    # Start of validation methods for initial call off period

    def initial_call_off_period_length
      return if errors[:initial_call_off_period_years].any? || errors[:initial_call_off_period_months].any?

      errors.add(:base, :total_contract_period) if initial_call_off_period > 7.years || initial_call_off_period.zero?
    end

    def initial_call_off_start_date_present
      errors.add(:initial_call_off_start_date, :blank) if initial_call_off_start_date_yyyy.blank? || initial_call_off_start_date_mm.blank? || initial_call_off_start_date_dd.blank?
    end

    def initial_call_off_start_date_real
      errors.add(:initial_call_off_start_date, :not_a_date) unless Date.valid_date?(initial_call_off_start_date_yyyy.to_i, initial_call_off_start_date_mm.to_i, initial_call_off_start_date_dd.to_i)
    end

    # End of validation methods for initial call off period
    #############################################

    #############################################
    # Start of validation methods for mobilisation period

    def mobilisation_period_in_past?
      return false unless mobilisation_period_required

      mobilisation_start_date.to_date <= Time.now.in_time_zone('London').to_date
    end

    def mobilisation_start_date_validation
      return unless mobilisation_period_in_past?

      errors.add(:mobilisation_start_date, :greater_than)
      errors.add(:mobilisation_period_required, '')
      errors.add(:initial_call_off_start_date, '')
    end

    # end of validation methods for mobilisation period
    #############################################

    #############################################
    # Start of validation methods for the overall contract period

    def total_contract_length
      return if errors.any?

      start_date = mobilisation_period_required ? mobilisation_start_date : initial_call_off_start_date

      end_date = initial_call_off_end_date

      end_date += call_off_extensions.select(&:extension_required).sum(&:period) if extensions_required

      return if end_date <= start_date + 10.years

      errors.add(:base, :total_contract_length)
    end

    def remove_empty_extensions
      return if errors.any?

      call_off_extensions.reject(&:extension_required).each(&:delete)
    end

    # End of validation methods for the overall contract period
    #############################################

    def validate_not_all_mandatory
      errors.add(:service_codes, :invalid_cafm_helpdesk_billable) if (service_codes - self.class::MANDATORY_SERVICES).empty?
    end

    def at_least_one_active_procurement_building
      errors.add(:procurement_buildings, :invalid) unless procurement_buildings.map(&:active).any?(true)
    end

    def all_buildings_have_regions
      errors.add(:base, :missing_regions) if procurement_buildings_missing_regions?
    end

    #############################################
    # Start of validation methods for contract period when continuing from the requirements page

    def check_contract_period_completed
      if contract_period_status == :completed
        errors.add(:base, :initial_call_off_period_in_past) if contract_period_in_past?
        errors.add(:base, :mobilisation_period_in_past) if mobilisation_period_in_past?
        errors.add(:base, :mobilisation_period_required) unless mobilisation_period_valid_when_tupe_required?
      else
        errors.add(:base, :contract_period_incomplete)
      end
    end

    def contract_period_in_past?
      initial_call_off_start_date < Time.now.in_time_zone('London').to_date
    end

    def mobilisation_period_valid_when_tupe_required?
      return true unless tupe

      mobilisation_period_required && mobilisation_period >= 4
    end

    # End of validation methods for contract period when continuing from the requirements page
    #############################################

    def check_service_and_buildings_present
      errors.add(:base, :services_incomplete) unless services_status == :completed
      errors.add(:base, :buildings_incomplete) unless buildings_status == :completed
    end

    def error_list
      errors.details[:base].pluck(:error)
    end
  end
end
