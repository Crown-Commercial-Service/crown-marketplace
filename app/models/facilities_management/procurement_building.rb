require 'facilities_management/fm_buildings_data'
module FacilitiesManagement
  class ProcurementBuilding < ApplicationRecord
    default_scope { order(name: :asc) }
    scope :active, -> { where(active: true) }
    belongs_to :procurement, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_buildings
    has_many :procurement_building_services, foreign_key: :facilities_management_procurement_building_id, inverse_of: :procurement_building, dependent: :destroy
    accepts_nested_attributes_for :procurement_building_services, allow_destroy: true

    validate :service_codes_not_empty, on: :building_services

    before_validation :cleanup_service_codes
    after_save :update_procurement_building_services

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

    def update_procurement_building_services
      (service_codes + procurement_building_services.map(&:code)).uniq.each do |service_code|
        if service_codes.include?(service_code)
          procurement_building_services.create(code: service_code, name: Service.find_by(code: service_code).try(:name)) if procurement_building_services.find_by(code: service_code).blank?
        else
          procurement_building_services.find_by(code: service_code).destroy
        end
      end
    end
  end
end
