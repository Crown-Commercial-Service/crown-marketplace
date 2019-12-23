module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM
    include ProcurementValidator

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    has_many :procurement_buildings, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true
    acts_as_gov_uk_date :initial_call_off_start_date, :security_policy_document_date, error_clash_behaviour: :omit_gov_uk_date_field_error
    mount_uploader :security_policy_document_file, FacilitiesManagementSecurityPolicyDocumentUploader
    # needed to move this validation here as it was being called incorrectly in the validator, ie when a file with the wrong
    # extension or size was being uploaded. The error message for this rather than the carrierwave error messages were being displayed
    validates :security_policy_document_file, presence: true, if: :security_policy_document_required?
    validates :security_policy_document_file, antivirus: true

    # attribute to hold and validate the user's selection from the view
    attribute :route_to_market
    validates :route_to_market, inclusion: { in: %w[direct_award further_competition] }, on: :route_to_market

    def unanswered_contract_date_questions?
      initial_call_off_period.nil? || initial_call_off_start_date.nil? || mobilisation_period_required.nil? || mobilisation_period_required.nil?
    end

    aasm do
      state :quick_search, initial: true
      state :detailed_search
      state :direct_award
      state :further_competition

      event :start_detailed_search do
        transitions from: :quick_search, to: :detailed_search
      end

      event :start_direct_award do
        transitions from: :detailed_search, to: :direct_award
      end

      event :start_further_competition do
        transitions from: :detailed_search, to: :further_competition
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
  end
end
