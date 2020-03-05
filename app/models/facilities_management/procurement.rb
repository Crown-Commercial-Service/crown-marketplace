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
    has_many :active_procurement_buildings, -> { where(active: true) }, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementBuilding', inverse_of: :procurement, dependent: :destroy
    has_many :procurement_building_services, through: :active_procurement_buildings
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

    has_many :procurement_suppliers, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy

    has_one :invoice_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementInvoiceContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :invoice_contact_detail, allow_destroy: true

    has_one :authorised_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementAuthorisedContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :authorised_contact_detail, allow_destroy: true

    has_one :notices_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementNoticesContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :notices_contact_detail, allow_destroy: true

    has_one :contract_details, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement
    accepts_nested_attributes_for :contract_details, allow_destroy: true

    has_many :procurement_pension_funds, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy, index_errors: true
    accepts_nested_attributes_for :procurement_pension_funds, allow_destroy: true, reject_if: :more_than_max_pensions?

    acts_as_gov_uk_date :initial_call_off_start_date, :security_policy_document_date, error_clash_behaviour: :omit_gov_uk_date_field_error

    has_one_attached :security_policy_document_file
    # needed to move this validation here as it was being called incorrectly in the validator, ie when a file with the wrong
    # extension or size was being uploaded. The error message for this rather than the carrierwave error messages were being displayed
    validates :security_policy_document_file, attached: true, if: :security_policy_document_required?
    validates :security_policy_document_file, content_type: %w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document]
    validates :security_policy_document_file, size: { less_than: 10.megabytes }
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
      state :direct_award, before_enter: :offer_to_next_supplier
      state :further_competition
      state :closed, before_enter: :set_close_date

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

      event :set_state_to_direct_award do
        transitions to: :direct_award
      end

      event :set_state_to_closed do
        transitions to: :closed
      end

      event :start_further_competition do
        transitions to: :further_competition
      end
    end

    def move_to_next_da_step
      next_event = aasm(:da_journey).events(reject: :start_da_journey, permitted: true).first
      aasm(:da_journey).fire!(next_event.name) if next_event.present?
    end
    aasm(:da_journey, column: 'da_journey_state') do
      state :pricing, initial: true
      state :what_next
      state :important_information
      state :contract_details
      state :review_and_generate
      state :review
      state :sending
      state :sent

      event :start_da_journey do
        transitions to: :pricing
      end

      event :set_to_what_next do
        transitions from: :pricing, to: :what_next
      end

      event :set_to_important_information do
        transitions from: :what_next, to: :important_information
      end

      event :set_to_contract_details do
        transitions from: :important_information, to: :contract_details
      end

      event :set_to_review_and_generate do
        transitions from: :contract_details, to: :review_and_generate
      end

      event :set_to_review do
        transitions from: :review_and_generate, to: :review
      end

      event :set_to_sending do
        transitions from: :review, to: :sending
      end

      event :set_to_sent do
        transitions from: :sending, to: :sent
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
      procurement_building_services.any? && active_procurement_buildings.all? { |p| p.valid?(:procurement_building_services) }
    end

    def save_eligible_suppliers_and_set_state
      eligible_suppliers = FacilitiesManagement::DirectAwardEligibleSuppliers.new(id)

      self.assessed_value = eligible_suppliers.assessed_value
      self.lot_number = eligible_suppliers.lot_number

      # if any procurement_suppliers present, they need to be removed
      procurement_suppliers.destroy_all
      eligible_suppliers.sorted_list.each do |supplier_data|
        procurement_suppliers.create(supplier_id: CCS::FM::Supplier.supplier_name(supplier_data[0].to_s).id, direct_award_value: supplier_data[1])
      end

      self.eligible_for_da = DirectAward.new(buildings_standard, services_standard, priced_at_framework, assessed_value).calculate
      set_state_to_results
      start_da_journey
      save
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
    SEARCH_ORDER = SEARCH.map(&:to_s)

    MAX_NUMBER_OF_PENSIONS = 99

    def direct_award?
      aasm_state.match?(/\Ada_/)
    end

    def extension_period_1_start_date
      return nil if optional_call_off_extensions_1.nil?

      initial_call_off_start_date + initial_call_off_period.years
    end

    def extension_period_1_end_date
      return nil if optional_call_off_extensions_1.nil?

      initial_call_off_start_date + (initial_call_off_period + optional_call_off_extensions_1).years - 1.day
    end

    def extension_period_2_start_date
      return nil if optional_call_off_extensions_2.nil?

      initial_call_off_start_date + (initial_call_off_period + optional_call_off_extensions_1).years
    end

    def extension_period_2_end_date
      return nil if optional_call_off_extensions_2.nil?

      initial_call_off_start_date + (initial_call_off_period + optional_call_off_extensions_1 + optional_call_off_extensions_2).years - 1.day
    end

    def extension_period_3_start_date
      return nil if optional_call_off_extensions_3.nil?

      initial_call_off_start_date + (initial_call_off_period + optional_call_off_extensions_1 + optional_call_off_extensions_2).years
    end

    def extension_period_3_end_date
      return nil if optional_call_off_extensions_3.nil?

      initial_call_off_start_date + (initial_call_off_period + optional_call_off_extensions_1 + optional_call_off_extensions_2 + optional_call_off_extensions_3).years - 1.day
    end

    def extension_period_4_start_date
      return nil if optional_call_off_extensions_4.nil?

      initial_call_off_start_date + (initial_call_off_period + optional_call_off_extensions_1 + optional_call_off_extensions_2 + optional_call_off_extensions_3).years
    end

    def extension_period_4_end_date
      return nil if optional_call_off_extensions_4.nil?

      initial_call_off_start_date + (initial_call_off_period + optional_call_off_extensions_1 + optional_call_off_extensions_2 + optional_call_off_extensions_3 + optional_call_off_extensions_4).years - 1.day
    end

    def sent_offers
      procurement_suppliers.where.not(aasm_state: 'unsent').reject(&:closed?)
    end

    def live_contracts
      procurement_suppliers.where(aasm_state: 'signed')
    end

    def closed_contracts
      procurement_suppliers.where.not(aasm_state: 'unsent').select(&:closed?)
    end

    def set_close_date
      procurement_suppliers.where.not(aasm_state: 'unsent').last.update(contract_closed_date: DateTime.now.in_time_zone('London'))
    end
    def offer_to_next_supplier
      return false if procurement_suppliers.unsent.empty?

      procurement_suppliers.unsent&.first&.offer_to_supplier!
    end

    private

    def update_procurement_building_services
      procurement_buildings.each do |building|
        building.service_codes.select! { |service_code| service_codes.include? service_code }
      end

      procurement_building_services.where.not(code: service_codes).destroy_all
    end

    def more_than_max_pensions?
      procurement_pension_funds.reject(&:marked_for_destruction?).size >= MAX_NUMBER_OF_PENSIONS
    end

    def assign_contract_number_to_procurement
      procurement_supplier = procurement_suppliers.first
      return unless procurement_supplier.contract_number.nil?

      procurement_supplier.assign_contract_number
      procurement_supplier.save
    end
  end
end
