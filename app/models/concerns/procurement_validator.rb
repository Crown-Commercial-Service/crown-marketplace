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
  end
end
