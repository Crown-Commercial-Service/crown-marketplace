require 'fm_calculator/fm_direct_award_calculator.rb'

module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM
    include ProcurementValidator

    # buyer
    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    before_save :update_procurement_building_services, if: :service_codes_changed?
    before_save :set_state_to_results, if: :buyer_selected_contract_value?

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

    has_many :procurement_pension_funds, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy, index_errors: true, before_add: :before_each_procurement_pension_funds
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

    # For making a copy of a procurement
    amoeba do
      exclude_association :procurement_suppliers
      exclude_association :active_procurement_buildings
    end

    def create_procurement_copy
      procurement_copy = amoeba_dup
      procurement_copy.contract_name = nil
      procurement_copy.aasm_state = 'detailed_search'
      procurement_copy.da_journey_state = 'pricing'
      if security_policy_document_required
        procurement_copy.security_policy_document_file = nil
        procurement_copy.security_policy_document_file.attach(security_policy_document_file.blob)
      end
      procurement_copy
    end

    def assign_contract_number_fc
      self.contract_number = generate_contract_number_fc
    end

    def assign_contract_datetime
      self.contract_datetime = Time.now.in_time_zone('London').strftime('%d/%m/%Y -%l:%M%P')
    end

    def generate_contract_number_fc
      ContractNumberGenerator.new(procurement_state: :further_competition, used_numbers: self.class.used_further_competition_contract_numbers_for_current_year).new_number
    end

    def self.used_further_competition_contract_numbers_for_current_year
      where('contract_number like ?', 'RM3860-FC%')
        .where('contract_number like ?', "%-#{Date.current.year}")
        .pluck(:contract_number)
        .map { |contract_number| contract_number.split('-')[1].split('FC')[1] }
    end

    def before_each_procurement_pension_funds(new_pension_fund)
      new_pension_fund.case_sensitive_error = false
      procurement_pension_funds.each do |saved_pension_fund|
        new_pension_fund.case_sensitive_error = true if (saved_pension_fund.name_downcase == new_pension_fund.name_downcase) && (saved_pension_fund.object_id != new_pension_fund.object_id)
      end
    end

    def unanswered_contract_date_questions?
      initial_call_off_period.nil? || initial_call_off_start_date.nil? || mobilisation_period_required.nil? || mobilisation_period_required.nil?
    end

    # rubocop:disable Metrics/BlockLength
    aasm do
      state :quick_search, initial: true
      state :detailed_search
      state :choose_contract_value
      state :results
      state :da_draft
      state :direct_award, before_enter: :offer_to_next_supplier
      state :further_competition
      state :closed, before_enter: :set_close_date

      event :set_state_to_results_if_possible do
        before do
          save_results_data
          contract_value_needed? ? remove_buyer_choice : save_data_if_contract_value_not_required
        end
        transitions from: :detailed_search, to: :choose_contract_value do
          guard do
            contract_value_needed?
          end
        end
        transitions from: %i[detailed_search da_draft], to: :results, after: :start_da_journey
      end

      event :set_state_to_choose_contract_value do
        transitions from: :results, to: :choose_contract_value
      end

      event :set_state_to_results do
        transitions from: :choose_contract_value, to: :results, after: :start_da_journey
        after do
          copy_fm_rates_to_frozen
          copy_fm_rate_cards_to_frozen
        end
      end

      event :set_state_to_detailed_search do
        before do
          remove_buyer_choice
        end
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
        after do
          assign_contract_number_fc
          assign_contract_datetime
        end
      end
    end
    # rubocop:enable Metrics/BlockLength

    def copy_fm_rates_to_frozen
      ActiveRecord::Base.transaction do
        CCS::FM::Rate.all.find_each do |rate|
          new_rate = CCS::FM::FrozenRate.new
          new_rate.facilities_management_procurement_id = id
          new_rate.code = rate.code
          new_rate.framework = rate.framework
          new_rate.benchmark = rate.benchmark
          new_rate.standard = rate.standard
          new_rate.direct_award = rate.direct_award
          new_rate.save!
        end
      end
    rescue ActiveRecord::Rollback => e
      logger.error e.message
    end

    def copy_fm_rate_cards_to_frozen
      latest_rate_card = CCS::FM::RateCard.latest
      new_rate_card = CCS::FM::FrozenRateCard.new
      new_rate_card.facilities_management_procurement_id = id
      new_rate_card.data = latest_rate_card.data
      new_rate_card.source_file = latest_rate_card.source_file
      new_rate_card.save!
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

    SEARCH = %i[quick_search detailed_search choose_contract_value results].freeze
    SEARCH_ORDER = SEARCH.map(&:to_s)

    MAX_NUMBER_OF_PENSIONS = 99

    def initial_call_off_end_date
      initial_call_off_start_date + initial_call_off_period.years - 1.day
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
      procurement_suppliers.where(aasm_state: %w[sent accepted declined expired not_signed]).reject(&:closed?)
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
      return false if procurement_suppliers.unsent.where(direct_award_value: 0..0.15e7).empty?

      unless procurement_suppliers.where(direct_award_value: 0..0.15e7).where.not(aasm_state: 'unsent').empty?
        last_contract = procurement_suppliers.where(direct_award_value: 0..0.15e7).where.not(aasm_state: 'unsent').last
        last_contract.update(contract_closed_date: last_contract.set_contract_closed_date)
      end
      procurement_suppliers.unsent.where(direct_award_value: 0..0.15e7)&.first&.offer_to_supplier!
    end

    def mobilisation_period_start_date
      return nil if mobilisation_period.nil?

      mobilisation_period_end_date - mobilisation_period.weeks
    end

    def mobilisation_period_end_date
      return nil if mobilisation_period.nil?

      initial_call_off_start_date - 1.day
    end

    def first_unsent_contract
      procurement_suppliers.find_by(aasm_state: 'unsent')
    end

    def procurement_building_service_codes
      procurement_building_services.map(&:code).uniq
    end

    def active_procurement_building_region_codes
      active_procurement_buildings.map { |proc_building| proc_building.building.address_region_code } .uniq
    end

    def procurement_building_services_not_used_in_calculation
      procurement_building_services.select { |service| CCS::FM::Rate.framework_rate_for(service.code).nil? || CCS::FM::Rate.benchmark_rate_for(service.code).nil? }.map(&:name).uniq
    end

    def some_services_unpriced_and_no_buyer_input?
      percentage_of_services_missing_framework_and_benchmark_price < 1 && !estimated_cost_known?
    end

    private

    def save_results_data
      eligible_suppliers = FacilitiesManagement::EligibleSuppliers.new(id)

      self.assessed_value = eligible_suppliers.assessed_value
      self.eligible_for_da = DirectAward.new(buildings_standard, services_standard, priced_at_framework, assessed_value).calculate

      # if any procurement_suppliers present, they need to be removed
      procurement_suppliers.destroy_all
      eligible_suppliers.sorted_list.each do |supplier_data|
        procurement_suppliers.create(supplier_id: CCS::FM::Supplier.supplier_name(supplier_data[0].to_s).id, direct_award_value: supplier_data[1])
      end

      save
    end

    def save_data_if_contract_value_not_required
      eligible_suppliers = FacilitiesManagement::EligibleSuppliers.new(id)

      self.lot_number = eligible_suppliers.lot_number
      self.lot_number_selected_by_customer = false
    end

    def remove_buyer_choice
      self.lot_number_selected_by_customer = nil
      self.lot_number = nil
    end

    def all_services_unpriced_and_no_buyer_input?
      all_services_missing_framework_price? && all_services_missing_benchmark_price? && !estimated_cost_known?
    end

    def buyer_selected_contract_value?
      lot_number_selected_by_customer_changed? && aasm_state == 'choose_contract_value' && lot_number_selected_by_customer
    end

    def update_procurement_building_services
      procurement_buildings.each do |building|
        building.service_codes.select! { |service_code| service_codes.include? service_code }
      end

      procurement_building_services.where.not(code: service_codes).destroy_all
    end

    def more_than_max_pensions?
      procurement_pension_funds.reject(&:marked_for_destruction?).size >= MAX_NUMBER_OF_PENSIONS
    end

    def all_services_missing_framework_price?
      procurement_building_services.all? { |pbs| CCS::FM::Rate.framework_rate_for(pbs.code, pbs.service_standard).nil? }
    end

    def all_services_missing_benchmark_price?
      procurement_building_services.all? { |pbs| CCS::FM::Rate.benchmark_rate_for(pbs.code, pbs.service_standard).nil? }
    end

    def contract_value_needed?
      (all_services_unpriced_and_no_buyer_input? || some_services_unpriced_and_no_buyer_input?) && !lot_number_selected_by_customer
    end

    def percentage_of_services_missing_framework_and_benchmark_price
      uniq_building_services = procurement_building_services.all.uniq
      unpriced_services = uniq_building_services.select { |pbs| CCS::FM::Rate.benchmark_rate_for(pbs.code, pbs.service_standard).nil? || CCS::FM::Rate.framework_rate_for(pbs.code, pbs.service_standard).nil? }
      unpriced_services.size / uniq_building_services.size.to_f
    end
  end
end
