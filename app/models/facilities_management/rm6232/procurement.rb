module FacilitiesManagement
  module RM6232
    class Procurement < ApplicationRecord
      include AASM
      include ProcurementConcern
      include RM6232::ProcurementValidator

      belongs_to :user, inverse_of: :rm6232_procurements

      has_many :call_off_extensions, foreign_key: :facilities_management_rm6232_procurement_id, inverse_of: :procurement, dependent: :destroy
      accepts_nested_attributes_for :call_off_extensions, allow_destroy: true

      has_many :procurement_buildings, foreign_key: :facilities_management_rm6232_procurement_id, inverse_of: :procurement, dependent: :destroy
      accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

      acts_as_gov_uk_date :initial_call_off_start_date, error_clash_behaviour: :omit_gov_uk_date_field_error

      scope :searches, -> { where(aasm_state: SEARCH).select(:id, :contract_name, :aasm_state, :initial_call_off_start_date, :updated_at).order(updated_at: :asc).sort_by { |search| SEARCH.index(search.aasm_state) } }
      scope :advanced_procurement_activities, -> { further_information.select(:id, :contract_name, :initial_call_off_start_date, :contract_number, :updated_at).order(updated_at: :asc) }

      before_save :update_procurement_building_service_codes, if: :service_codes_changed?
      before_create :generate_contract_number, :determine_lot_number

      # The service CAFM – Soft FM Requirements (Q.1) can only be selected when all other services are soft.
      # Because we don't want to pass that logic onto the user, we determine which CAFM service they need for them.
      # To make the selection easier we have added the Q.3 service for the user to select,
      # which we can then replace with the correct CAFM service at the appropriate time.
      # You can read more information at: https://crowncommercialservice.atlassian.net/l/c/XW2DSi72

      def quick_view_suppliers
        @quick_view_suppliers ||= SuppliersSelector.new(service_codes_without_cafm, region_codes, annual_contract_value)
      end

      def supplier_names
        SuppliersSelector.new(service_codes_without_cafm, region_codes, annual_contract_value, lot_number).selected_suppliers.pluck(:supplier_name)
      end

      def suppliers
        @suppliers ||= SuppliersSelector.new(procurement_buildings_service_codes_without_cafm, procurement_buildings_region_codes, annual_contract_value)
      end

      def services
        @services ||= Service.where(code: true_service_codes).order(:work_package_code, :sort_order)
      end

      def procurement_services
        @procurement_services ||= Service.where(code: true_procurement_buildings_service_codes).order(:work_package_code, :sort_order)
      end

      def services_without_lot_consideration
        @services_without_lot_consideration ||= Service.where(code: service_codes).order(:work_package_code, :sort_order)
      end

      def regions
        @regions ||= Region.where(code: region_codes)
      end

      def active_procurement_buildings
        @active_procurement_buildings ||= procurement_buildings.where(active: true)
      end

      aasm do
        state :what_happens_next, initial: true
        state :entering_requirements
        state :results, before_enter: %i[freeze_data determine_lot]
        state :further_information

        event :set_to_next_state do
          transitions from: :what_happens_next, to: :entering_requirements
          transitions from: :entering_requirements, to: :results
          transitions from: :results, to: :further_information
        end

        event :go_back_to_entering_requirements do
          transitions from: :results, to: :entering_requirements
        end
      end

      SEARCH = %w[what_happens_next entering_requirements results].freeze

      def annual_contract_value_status
        annual_contract_value.present? ? :completed : :not_started
      end

      def procurement_buildings_missing_regions?
        return false unless entering_requirements?

        active_procurement_buildings.includes(:building).pluck('facilities_management_buildings.address_region_code').any?(&:blank?)
      end

      private

      def service_codes_without_cafm
        service_codes - ['Q.3']
      end

      def true_service_codes
        return service_codes unless service_codes.include?('Q.3')

        if lot_number.start_with? '3'
          service_codes_without_cafm + ['Q.1']
        else
          service_codes_without_cafm + ['Q.2']
        end
      end

      def generate_contract_number
        self.contract_number = ContractNumberGenerator.new(framework: 'RM6232', model: self.class).new_number
      end

      def determine_lot_number
        self.lot_number = Service.find_lot_number(service_codes_without_cafm, annual_contract_value)
      end

      def update_procurement_building_service_codes
        procurement_buildings.each do |procurement_building|
          procurement_building.service_codes.select! { |service_code| service_codes&.include? service_code }
        end
      end

      def freeze_data
        active_procurement_buildings.each(&:freeze_building_data)
      end

      def determine_lot
        self.lot_number = Service.find_lot_number(procurement_buildings_service_codes_without_cafm, annual_contract_value)
      end

      def procurement_buildings_service_codes
        @procurement_buildings_service_codes ||= active_procurement_buildings.map(&:service_codes).flatten.uniq
      end

      def procurement_buildings_service_codes_without_cafm
        procurement_buildings_service_codes - ['Q.3']
      end

      def true_procurement_buildings_service_codes
        return procurement_buildings_service_codes unless procurement_buildings_service_codes.include?('Q.3')

        if lot_number.start_with? '3'
          procurement_buildings_service_codes_without_cafm + ['Q.1']
        else
          procurement_buildings_service_codes_without_cafm + ['Q.2']
        end
      end

      def procurement_buildings_region_codes
        active_procurement_buildings.map { |procurement_building| procurement_building.get_frozen_attribute('address_region_code') }.uniq
      end

      MANDATORY_SERVICES = %w[Q.3 R.1 S.1].freeze
    end
  end
end
