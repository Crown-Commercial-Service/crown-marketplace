module FacilitiesManagement
  class ProcurementPensionFund < ApplicationRecord
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_pension_funds, optional: true
  end
end
