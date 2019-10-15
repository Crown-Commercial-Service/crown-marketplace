module FacilitiesManagement
  class ProcurementBuilding < ApplicationRecord
    default_scope { order(name: :asc) }
    scope :active, -> { where(active: true) }
    belongs_to :procurement, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_buildings

    validate :service_codes_not_empty, on: :building_services

    before_validation :cleanup_service_codes

    def full_address
      "#{address_line_1 + ', ' if address_line_1.present?}
      #{address_line_2 + ', ' if address_line_2.present?}
      #{town + ', ' if town.present?}
      #{county + ', ' if county.present?}
      #{postcode}"
    end

    private

    def service_codes_not_empty
      return unless active

      errors.add(:service_codes, :invalid) if service_codes.empty?
    end

    def cleanup_service_codes
      self.service_codes = service_codes.reject(&:blank?)
    end
  end
end
