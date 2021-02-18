module FacilitiesManagement
  class Procurement::OptionalCallOffExtension < ApplicationRecord
    belongs_to :procurement, foreign_key: :facilities_management_procurement_id, inverse_of: :optional_call_off_extensions

    attr_accessor :extension_required

    before_validation :convert_to_boolean, on: :contract_period
    validates :years, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 0 }, if: -> { extension_required }, on: :contract_period
    validates :months, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 11 }, if: -> { extension_required }, on: :contract_period
    validate :minimum_period_length, if: -> { extension_required }, on: :contract_period

    validates :extension, presence: true, inclusion: { in: (0..3) }, uniqueness: { scope: :procurement }, if: -> { extension_required }, on: :contract_period

    def period
      years.years + months.months
    end

    private

    def minimum_period_length
      return if errors[:years].any? || errors[:months].any?

      errors.add(:base, :minimum_period, extension: extension + 1) if period.zero?
    end

    def convert_to_boolean
      self.extension_required = extension_required == 'true'
    end
  end
end
