module FacilitiesManagement
  class ProcurementPensionFund < ApplicationRecord
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_pension_funds

    # validations on :pension_fund step
    validates :name, presence: true, on: :pension_fund
    validates :name, length: 1..150, on: :pension_fund
    validates :percentage, presence: true, on: :pension_fund
    validates :percentage, inclusion: 1..100, on: :pension_fund
  end
end
