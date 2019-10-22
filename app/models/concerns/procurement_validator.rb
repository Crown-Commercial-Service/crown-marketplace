module ProcurementValidator
  extend ActiveSupport::Concern

  included do
    # validations on :name step
    validates :name, presence: true, on: :name
    validates :name, uniqueness: { scope: :user }, on: :name
    validates :name, length: 1..100, on: :name

    # validations on :contract_name step
    validates :contract_name, presence: true, on: :contract_name
    validates :contract_name, length: 1..100, on: :contract_name

    # validations on :estimated_annual_cost step
    validates :estimated_annual_cost, presence: true, if: -> { estimated_cost_known? }, on: :estimated_annual_cost

    # validations on :procurement_buildings step
    validate :at_least_one_active_procurement_building, on: :procurement_buildings

    validate :service_codes_not_empty, on: :services

    private

    def at_least_one_active_procurement_building
      errors.add(:procurement_buildings, :invalid) unless procurement_buildings.map(&:active).any?(true)
    end

    def service_codes_not_empty
      errors.add(:service_codes, :invalid) if defined?(service_codes) && service_codes.empty?
    end
  end
end
