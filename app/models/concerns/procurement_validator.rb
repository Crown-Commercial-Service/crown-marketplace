module ProcurementValidator
  extend ActiveSupport::Concern

  included do
    # validations on :create
    validates :name, presence: true, on: :create
    validates :name, uniqueness: { scope: :user }, on: :create
    validates :name, length: 1..100, on: :create

    # validations on :contract_name step
    validates :contract_name, presence: true, on: :contract_name
    validates :contract_name, length: 1..100, on: :contract_name

    # validations on :annual_cost step
    validates :estimated_annual_cost, presence: true, on: :annual_cost
  end
end