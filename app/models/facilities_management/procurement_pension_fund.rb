module FacilitiesManagement
  class ProcurementPensionFund < ApplicationRecord
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_pension_funds, optional: true
    validates :name, :percentage, presence: true
    validates :name, length: { maximum: 150 }
    validates :percentage, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
  end
end
