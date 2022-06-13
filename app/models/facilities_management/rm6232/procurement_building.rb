module FacilitiesManagement
  module RM6232
    class ProcurementBuilding < ApplicationRecord
      scope :active, -> { where(active: true) }
      scope :order_by_building_name, -> { joins(:building).merge(FacilitiesManagement::Building.order(FacilitiesManagement::Building.arel_table['building_name'].lower.asc)) }

      belongs_to :procurement, foreign_key: :facilities_management_rm6232_procurement_id, inverse_of: :procurement_buildings
      belongs_to :building, class_name: 'FacilitiesManagement::Building'

      delegate :building_name, to: :building
      delegate :full_address, to: :building
      delegate :address_no_region, to: :building

      before_validation :cleanup_service_codes, on: :buildings_and_services
      validates :service_codes, length: { minimum: 1 }, on: :buildings_and_services
      validate :service_code_selection, on: :buildings_and_services

      def service_selection_complete?
        service_codes.any? && !all_mandatory?
      end

      def service_names
        @service_names ||= Service.where(code: service_codes).order(:work_package_code, :sort_order).pluck(:name)
      end

      def missing_region?
        building.address_region_code.blank? || building.address_region.blank?
      end

      private

      def cleanup_service_codes
        self.service_codes = service_codes.reject(&:blank?)
      end

      def service_code_selection
        return if errors.include?(:service_codes)

        validate_cleaning_services_selection
        validate_not_all_mandatory
      end

      def validate_cleaning_services_selection
        errors.add(:service_codes, :invalid_cleaning) if CLEANING_SERVICES.all? { |service_code| service_codes.include? service_code }
      end

      def validate_not_all_mandatory
        errors.add(:service_codes, :invalid_cafm_helpdesk_billable) if all_mandatory?
      end

      def all_mandatory?
        (service_codes - MANDATORY_SERVICES).empty?
      end

      CLEANING_SERVICES = %w[I.1 I.4].freeze
      MANDATORY_SERVICES = %w[Q.3 R.1 S.1].freeze
    end
  end
end
