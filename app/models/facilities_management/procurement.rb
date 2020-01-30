require 'fm_calculator/fm_direct_award_calculator.rb'
module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM
    include ProcurementValidator
    # include ProcurementPensionFundValidator

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    before_save :update_procurement_building_services, if: :service_codes_changed?

    has_many :procurement_buildings, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    has_many :procurement_building_services, through: :procurement_buildings
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

    has_many :procurement_suppliers, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy

    has_many :procurement_pension_funds, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :procurement_pension_funds, allow_destroy: true, reject_if: :any_pension_errors?

    acts_as_gov_uk_date :initial_call_off_start_date, :security_policy_document_date, error_clash_behaviour: :omit_gov_uk_date_field_error
    mount_uploader :security_policy_document_file, FacilitiesManagementSecurityPolicyDocumentUploader
    # needed to move this validation here as it was being called incorrectly in the validator, ie when a file with the wrong
    # extension or size was being uploaded. The error message for this rather than the carrierwave error messages were being displayed
    validates :security_policy_document_file, presence: true, if: :security_policy_document_required?
    validates :security_policy_document_file, antivirus: true

    # attribute to hold and validate the user's selection from the view
    attribute :route_to_market
    validates :route_to_market, inclusion: { in: %w[da_draft further_competition] }, on: :route_to_market

    def unanswered_contract_date_questions?
      initial_call_off_period.nil? || initial_call_off_start_date.nil? || mobilisation_period_required.nil? || mobilisation_period_required.nil?
    end

    aasm do
      state :quick_search, initial: true
      state :detailed_search
      state :results
      state :da_draft
      state :further_competition
      state :awaiting_supplier_response
      state :supplier_declined
      state :no_supplier_response
      state :awaiting_contract_signature
      state :accepted_not_signed
      state :accepted_and_signed
      state :withdrawn

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
        transitions to: :da_draft
      end

      event :start_further_competition do
        transitions to: :further_competition
      end
    end

    # rubocop: disable Metrics/BlockLength
    aasm(:da_journey, column: 'da_journey_state') do
      state :pricing, initial: true
      state :what_next
      state :important_information
      state :contract_details
      state :review_and_generate
      state :review
      state :sending
      state :sent_awaiting_response
      state :withdraw
      state :accepted
      state :confirmation
      state :accepted_signed
      state :accepted_not_signed
      state :declined
      state :no_response
      state :confirm_signed
      state :closed

      event :start_da_journey do
        transitions to: :pricing
      end

      event :set_to_what_next do
        transitions to: :what_next
      end

      event :set_to_important_information do
        transitions to: :important_information
      end

      event :set_to_contract_details do
        transitions to: :contract_details
      end

      event :set_to_review_and_generate do
        transitions to: :review_and_generate
      end

      event :set_to_review do
        transitions to: :review
      end

      event :set_to_sending do
        transitions to: :sending
      end

      event :set_to_sent_awaiting_response do
        transitions to: :sent_awaiting_response
      end

      event :set_to_withdraw do
        transitions to: :withdraw
      end

      event :set_to_accepted do
        transitions to: :accepted
      end

      event :set_to_confirmation do
        transitions to: :confirmation
      end

      event :set_to_accepted_signed do
        transitions to: :accepted_signed
      end

      event :set_to_accepted_not_signed do
        transitions to: :accepted_not_signed
      end

      event :set_to_declined do
        transitions to: :declined
      end

      event :set_to_no_response do
        transitions to: :no_response
      end

      event :set_to_confirm_signed do
        transitions to: :confirm_signed
      end

      event :set_to_closed do
        transitions to: :closed
      end
    end
    # rubocop: enable Metrics/BlockLength

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
      # if one service is not priced at framework, returns false
      !procurement_building_services.map { |pbs| CCS::FM::Rate.priced_at_framework(pbs.code, pbs.service_standard) }.include?(false)
    end

    SEARCH = %i[quick_search detailed_search results further_competition].freeze
    SENT_OFFER = %i[awaiting_supplier_response supplier_declined no_supplier_response awaiting_contract_signature accepted_not_signed].freeze
    SEARCH_ORDER = SEARCH.map(&:to_s)
    SENT_OFFER_ORDER = SENT_OFFER.map(&:to_s)

    MAX_NUMBER_OF_PENSIONS = 10

    def direct_award?
      aasm_state.match?(/\Ada_/)
    end

    # rubocop: disable Metrics/CyclomaticComplexity
    # rubocop: disable Metrics/PerceivedComplexity
    def any_pension_errors?(attributes)
      return false if attributes[:_destroy] == 'true'
      return true if valid_pension_count? >= MAX_NUMBER_OF_PENSIONS
      return true if attributes[:name].empty?
      return true if attributes[:name].length > 150
      return true if attributes[:percentage].empty?
      return true if attributes[:percentage].to_f < 1 || attributes[:percentage].to_f > 100
      return true if attributes[:percentage].to_f % 1 != 0

      false
    end
    # rubocop: enable Metrics/CyclomaticComplexity
    # rubocop: enable Metrics/PerceivedComplexity

    private

    def update_procurement_building_services
      procurement_buildings.each do |building|
        building.service_codes.select! { |service_code| service_codes.include? service_code }
      end

      procurement_building_services.where.not(code: service_codes).destroy_all
    end

    def valid_pension_count?
      procurement_pension_funds.reject(&:marked_for_destruction?).size
    end
  end
end
