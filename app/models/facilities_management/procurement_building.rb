module FacilitiesManagement
  class ProcurementBuilding < ApplicationRecord
    default_scope { order(name: :asc) }
    belongs_to :procurement, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_buildings

    validate :service_codes_not_empty

    private

    def service_codes_not_empty
      errors.add(:service_codes, :invalid) if service_codes.reject(&:blank?).empty?
    end
  end
end
