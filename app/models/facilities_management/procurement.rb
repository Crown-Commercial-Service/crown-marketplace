require 'fm_calculator/fm_direct_award_calculator.rb'
module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM
    include ProcurementValidator

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    before_save :update_procurement_building_services, if: :service_codes_changed?

    has_many :procurement_buildings, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    has_many :procurement_building_services, through: :procurement_buildings
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

    has_many :procurement_suppliers, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy

    acts_as_gov_uk_date :initial_call_off_start_date, :security_policy_document_date, error_clash_behaviour: :omit_gov_uk_date_field_error
    mount_uploader :security_policy_document_file, FacilitiesManagementSecurityPolicyDocumentUploader
    # needed to move this validation here as it was being called incorrectly in the validator, ie when a file with the wrong
    # extension or size was being uploaded. The error message for this rather than the carrierwave error messages were being displayed
    validates :security_policy_document_file, presence: true, if: :security_policy_document_required?
    validates :security_policy_document_file, antivirus: true

    # attribute to hold and validate the user's selection from the view
    attribute :route_to_market
    validates :route_to_market, inclusion: { in: %w[DA_draft further_competition] }, on: :route_to_market

    def unanswered_contract_date_questions?
      initial_call_off_period.nil? || initial_call_off_start_date.nil? || mobilisation_period_required.nil? || mobilisation_period_required.nil?
    end

    aasm do
      state :quick_search, initial: true
      state :detailed_search
      state :results
      state :DA_draft
      state :further_competition

      event :set_state_to_results do
        transitions to: :results
      end

      event :set_state_to_detailed_search do
        transitions to: :detailed_search
      end

      event :start_detailed_search do
        transitions from: :quick_search, to: :detailed_search
      end

      event :start_direct_award do
        transitions to: :DA_draft
      end

      event :start_further_competition do
        transitions to: :further_competition
      end
    end

    def find_or_build_procurement_building(building_data, building_id)
      procurement_building = procurement_buildings.find_or_initialize_by(name: building_data['name'])
      procurement_building.address_line_1 = building_data['address']['fm-address-line-1']
      procurement_building.address_line_2 = building_data['address']['fm-address-line-2']
      procurement_building.town = building_data['address']['fm-address-town']
      procurement_building.county = building_data['address']['fm-address-county']
      procurement_building.postcode = building_data['address']['fm-address-postcode']
      procurement_building.building_id = building_id
      procurement_building.save
    end

    def valid_on_continue?
      valid?(:all) && valid_services?
    end

    def valid_services?
      active_procurement_buildings.map(&:procurement_building_services).any? && active_procurement_buildings.all? { |p| p.valid?(:procurement_building_services) }
    end

    def active_procurement_buildings
      procurement_buildings.active
    end

    def save_eligible_suppliers
      sorted_list = FacilitiesManagement::DirectAwardEligibleSuppliers.new(id).sorted_list

      # if any procurement_suppliers present, they need to be removed
      procurement_suppliers.destroy_all
      sorted_list.each do |supplier_data|
        procurement_suppliers.create(supplier_id: CCS::FM::Supplier.supplier_name(supplier_data[0].to_s).id, direct_award_value: supplier_data[1])
      end
    end

    def buildings_standard
      active_procurement_buildings.map { |pb| pb.building.building_standard }.include?('NON-STANDARD') ? 'NON-STANDARD' : 'STANDARD'
    end

    def services_standard
      # 'A' if A or N/A, 'B' if 'B' or 'C' standards are present
      (procurement_building_services.map(&:service_standard).uniq.flatten - ['A']).none? ? 'A' : 'B'
    end

    def priced_at_framework
      # [procurement_building_services.map(&:code) - CCS::FM::Service.direct_award_services].none?
      # this is not the right list, still need to import this data
      # for now this always returns true
      true
    end

    private

    def update_procurement_building_services
      procurement_buildings.each do |building|
        building.service_codes.select! { |service_code| service_codes.include? service_code }
      end

      procurement_building_services.where.not(code: service_codes).destroy_all
    end
  end
end
