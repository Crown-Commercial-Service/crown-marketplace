module FacilitiesManagement
  module RM3830
    class Procurement < ApplicationRecord
      include AASM
      include ProcurementConcern
      include RM3830::ProcurementValidator
      include ServiceQuestionsConcern

      # buyer
      belongs_to :user, inverse_of: :rm3830_procurements

      before_save :update_procurement_building_services, if: :service_codes_changed?
      before_save :set_state_to_results, if: :buyer_selected_contract_value?

      has_many :call_off_extensions, foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement, dependent: :destroy
      accepts_nested_attributes_for :call_off_extensions, allow_destroy: true

      has_many :procurement_buildings, foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement, dependent: :destroy
      has_many :active_procurement_buildings, -> { where(active: true) }, foreign_key: :facilities_management_rm3830_procurement_id, class_name: 'FacilitiesManagement::RM3830::ProcurementBuilding', inverse_of: :procurement, dependent: :destroy
      has_many :procurement_building_services, through: :active_procurement_buildings
      accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

      has_many :procurement_suppliers, foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement, dependent: :destroy

      has_one :spreadsheet_import, foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement, dependent: :destroy

      has_one :invoice_contact_detail, foreign_key: :facilities_management_rm3830_procurement_id, class_name: 'FacilitiesManagement::RM3830::ProcurementInvoiceContactDetail', inverse_of: :procurement, dependent: :destroy
      accepts_nested_attributes_for :invoice_contact_detail, allow_destroy: true

      has_one :authorised_contact_detail, foreign_key: :facilities_management_rm3830_procurement_id, class_name: 'FacilitiesManagement::RM3830::ProcurementAuthorisedContactDetail', inverse_of: :procurement, dependent: :destroy
      accepts_nested_attributes_for :authorised_contact_detail, allow_destroy: true

      has_one :notices_contact_detail, foreign_key: :facilities_management_rm3830_procurement_id, class_name: 'FacilitiesManagement::RM3830::ProcurementNoticesContactDetail', inverse_of: :procurement, dependent: :destroy
      accepts_nested_attributes_for :notices_contact_detail, allow_destroy: true

      has_many :procurement_pension_funds, foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement, dependent: :destroy, index_errors: true, before_add: :before_each_procurement_pension_funds
      accepts_nested_attributes_for :procurement_pension_funds, allow_destroy: true, reject_if: :more_than_max_pensions?

      acts_as_gov_uk_date :initial_call_off_start_date, :security_policy_document_date, error_clash_behaviour: :omit_gov_uk_date_field_error

      has_one_attached :security_policy_document_file

      # attribute to hold and validate the user's selection from the view
      attribute :route_to_market
      validates :route_to_market, inclusion: { in: %w[da_draft further_competition_chosen further_competition] }, on: :route_to_market

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
        procurement_copy.contract_number = nil
        procurement_copy.lot_number = nil
        procurement_copy.lot_number_selected_by_customer = nil
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
        ContractNumberGenerator.new(procurement_state: :further_competition, framework: 'RM3830', model: self.class).new_number
      end

      def before_each_procurement_pension_funds(new_pension_fund)
        new_pension_fund.case_sensitive_error = false
        procurement_pension_funds.each do |saved_pension_fund|
          new_pension_fund.case_sensitive_error = true if (saved_pension_fund.name_downcase == new_pension_fund.name_downcase) && !saved_pension_fund.equal?(new_pension_fund)
        end
      end

      def unanswered_contract_date_questions?
        initial_call_off_period_years.nil? || initial_call_off_period_months.nil? || initial_call_off_start_date.nil? || mobilisation_period_required.nil? || mobilisation_period_required.nil?
      end

      # rubocop:disable Metrics/BlockLength
      aasm do
        state :quick_search, initial: true
        state :detailed_search
        state :detailed_search_bulk_upload
        state :choose_contract_value
        state :results
        state :da_draft
        state :direct_award, before_enter: :offer_to_next_supplier
        state :further_competition
        state :closed, before_enter: :set_close_date

        event :set_state_to_results_if_possible do
          before do
            freeze_procurement_data
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
            set_suppliers_for_procurement
          end
        end

        event :return_to_results do
          transitions from: :da_draft, to: :results, after: :start_da_journey
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

        event :start_detailed_search_bulk_upload do
          before do
            remove_existing_spreadsheet_import if spreadsheet_import.present?
          end
          transitions from: :detailed_search, to: :detailed_search_bulk_upload
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
            save
          end
        end
      end
      # rubocop:enable Metrics/BlockLength

      def copy_fm_rates_to_frozen
        ActiveRecord::Base.transaction do
          Rate.find_each do |rate|
            new_rate = FrozenRate.new
            new_rate.facilities_management_rm3830_procurement_id = id
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
        latest_rate_card = RateCard.latest
        new_rate_card = FrozenRateCard.new
        new_rate_card.facilities_management_rm3830_procurement_id = id
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

      def buildings_standard
        active_procurement_buildings.includes(:building).any? { |pb| pb.building.building_standard == 'NON-STANDARD' } ? 'NON-STANDARD' : 'STANDARD'
      end

      def services_standard
        # 'A' if A or N/A, 'B' if 'B' or 'C' standards are present
        (procurement_building_services.map(&:service_standard).uniq.flatten - ['A']).none? ? 'A' : 'B'
      end

      def priced_at_framework
        # if one service is not priced at framework, returns false
        procurement_building_services.reject(&:special_da_service?).none? { |pbs| pbs.service_missing_framework_price?(rate_model) }
      end

      SEARCH = %i[quick_search detailed_search detailed_search_bulk_upload choose_contract_value results].freeze
      SEARCH_ORDER = SEARCH.map(&:to_s)

      DIRECT_AWARD_VALUE_RANGE = (0..1.49999999e6)

      MAX_NUMBER_OF_PENSIONS = 99

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
        return false if unsent_direct_award_offers.empty?

        unless procurement_suppliers.where(direct_award_value: DIRECT_AWARD_VALUE_RANGE).where.not(aasm_state: 'unsent').empty?
          last_contract = procurement_suppliers.where(direct_award_value: DIRECT_AWARD_VALUE_RANGE).where.not(aasm_state: 'unsent').last
          last_contract.update(contract_closed_date: last_contract.set_contract_closed_date)
        end
        unsent_direct_award_offers&.first&.offer_to_supplier!
      end

      def unsent_direct_award_offers
        procurement_suppliers.unsent.where(direct_award_value: DIRECT_AWARD_VALUE_RANGE)
      end

      def first_unsent_contract
        procurement_suppliers.find_by(aasm_state: 'unsent')
      end

      def procurement_building_service_codes
        procurement_building_services.map(&:code).uniq
      end

      def procurement_building_service_codes_and_standards
        procurement_building_services.map { |s| [s.code, s.service_standard] }.uniq
      end

      def active_procurement_buildings_with_attribute_distinct(attribute)
        if building_data_frozen?
          active_procurement_buildings.distinct(attribute).pluck(attribute)
        else
          full_attribute = "facilities_management_buildings.#{attribute}"
          active_procurement_buildings.joins(:building).select(full_attribute).distinct(full_attribute).pluck(full_attribute)
        end
      end

      def active_procurement_buildings_with_attribute(attribute)
        if building_data_frozen?
          active_procurement_buildings.pluck(attribute).compact
        else
          full_attribute = "facilities_management_buildings.#{attribute}"
          active_procurement_buildings.joins(:building).select(full_attribute).pluck(full_attribute)
        end
      end

      def building_data_frozen?
        !(quick_search? || detailed_search? || detailed_search_bulk_upload?)
      end

      def procurement_building_services_not_used_in_calculation
        names = []
        services = procurement_building_services.select(:code, :service_standard, :name).uniq.reject(&:special_da_service?).pluck(:code, :service_standard, :name).uniq

        services.each do |service|
          pbs = ProcurementBuildingService.new(code: service[0], service_standard: service[1], name: service[2])
          names << pbs.name if pbs.service_missing_framework_price?(rate_model) && pbs.service_missing_benchmark_price?(rate_model)
        end

        names
      end

      def unused_service?(service)
        service.service_missing_framework_price?(rate_model) && service.service_missing_benchmark_price?(rate_model)
      end

      def some_services_unpriced_and_no_buyer_input?
        any_services_missing_framework_price? && any_services_missing_benchmark_price? && !estimated_cost_known?
      end

      def any_services_missing_framework_price?
        procurement_building_services.select(:code, :service_standard).uniq.reject(&:special_da_service?).any? { |pbs| pbs.service_missing_framework_price?(rate_model) }
      end

      def any_services_missing_benchmark_price?
        procurement_building_services.select(:code, :service_standard).uniq.reject(&:special_da_service?).any? { |pbs| pbs.service_missing_benchmark_price?(rate_model) }
      end

      def all_services_unpriced_and_no_buyer_input?
        all_services_missing_framework_price? && all_services_missing_benchmark_price? && !estimated_cost_known?
      end

      def all_services_missing_framework_price?
        procurement_building_services.select(:code, :service_standard).uniq.reject(&:special_da_service?).all? { |pbs| pbs.service_missing_framework_price?(rate_model) }
      end

      def all_services_missing_framework_and_benchmark_price?
        all_services_missing_framework_price? && all_services_missing_benchmark_price?
      end

      def estimated_annual_cost_status
        estimated_cost_known.nil? ? :not_started : :completed
      end

      def service_requirements_status
        return :cannot_start unless buildings_and_services_status == :completed
        return :not_required unless services_require_questions?

        service_requirements_completed? ? :completed : :incomplete
      end

      def service_requirements_completed?
        gia_complete? &&
          external_area_complete? &&
          services_requiring_lift_data_complete? &&
          services_requiring_volumes_complete? &&
          services_requiring_service_hours_complete? &&
          services_requiring_service_standard_complete?
      end

      def remove_existing_spreadsheet_import
        spreadsheet_import.destroy
      end

      def sorted_active_procurement_buildings
        active_procurement_buildings.order_by_building_name
      end

      def services
        sort_order = StaticData.work_packages.pluck('code')
        Service.where(code: service_codes)&.sort_by { |service| sort_order.index(service.code) }
      end

      def services_require_questions?
        procurement_building_service_codes.intersect?(services_requiring_questions)
      end

      def can_be_deleted?
        %w[quick_search detailed_search detailed_search_bulk_upload choose_contract_value results da_draft].include? aasm_state
      end

      def procurement_buildings_missing_regions?
        return false unless detailed_search? || detailed_search_bulk_upload?

        active_procurement_buildings.includes(:building).pluck('facilities_management_buildings.address_region_code').any?(&:blank?)
      end

      def contract_detail_incomplete?(contact_detail)
        send(contact_detail).present? && send(contact_detail).name.nil?
      end

      private

      def freeze_procurement_data
        return unless detailed_search?

        copy_procurement_buildings_data
        copy_fm_rates_to_frozen
        copy_fm_rate_cards_to_frozen
        calculate_initial_assesed_value
        save_data_for_procurement
      end

      def copy_procurement_buildings_data
        ActiveRecord::Base.transaction { active_procurement_buildings.includes(:building).find_each(&:freeze_building_data) }
      end

      def save_data_for_procurement
        self.lot_number = assessed_value_calculator.lot_number unless all_services_unpriced_and_no_buyer_input?
        self.lot_number_selected_by_customer = false
        self.eligible_for_da = DirectAward.new(buildings_standard, services_standard, priced_at_framework, assessed_value).calculate
        set_suppliers_for_procurement
      end

      def set_suppliers_for_procurement
        procurement_suppliers.destroy_all

        assessed_value_calculator.sorted_list(eligible_for_da).each do |supplier_data|
          procurement_suppliers.create!(supplier_id: supplier_data[:supplier_id], direct_award_value: supplier_data[:da_value])
        end
      end

      def calculate_initial_assesed_value
        self.assessed_value = assessed_value_calculator.assessed_value
      end

      def assessed_value_calculator
        @assessed_value_calculator ||= AssessedValueCalculator.new(id)
      end

      def rate_model
        frozen_rates ||= FrozenRate.where(facilities_management_rm3830_procurement_id: id)
        @rate_model ||= frozen_rates.empty? ? Rate : frozen_rates
      end

      def remove_buyer_choice
        self.lot_number_selected_by_customer = nil
        self.lot_number = nil
      end

      def buyer_selected_contract_value?
        lot_number_selected_by_customer_changed? && aasm_state == 'choose_contract_value' && lot_number_selected_by_customer
      end

      def update_procurement_building_services
        procurement_buildings.each do |building|
          building.service_codes.select! { |service_code| service_codes&.include? service_code }
        end
        procurement_building_services.where.not(code: service_codes).destroy_all
      end

      def more_than_max_pensions?
        procurement_pension_funds.reject(&:marked_for_destruction?).size >= MAX_NUMBER_OF_PENSIONS
      end

      def all_services_missing_benchmark_price?
        procurement_building_services.select(:code, :service_standard).uniq.reject(&:special_da_service?).all? { |pbs| pbs.service_missing_benchmark_price?(rate_model) }
      end

      def contract_value_needed?
        all_services_unpriced_and_no_buyer_input? || some_services_unpriced_and_no_buyer_input?
      end

      def gia_complete?
        building_area_complete?(:gia, services_requiring_gia)
      end

      def external_area_complete?
        building_area_complete?(:external_area, services_requiring_external_area)
      end

      def building_area_complete?(attribute, codes)
        full_attribute = "facilities_management_buildings.#{attribute}"

        active_procurement_buildings.where('service_codes && ARRAY[?]::text[]', codes).joins(:building).select(full_attribute).pluck(full_attribute).all?(&:positive?)
      end

      def services_requiring_lift_data_complete?
        procurement_building_services.where(code: services_requiring_lift_data).all? { |service| service.sum_number_of_floors.positive? }
      end

      def services_requiring_volumes_complete?
        volume_contexts.all? do |context|
          service_question_complete_for_codes?(service_quesions.get_codes_by_question(context), context)
        end
      end

      def services_requiring_service_hours_complete?
        service_question_complete_for_codes?(services_requiring_service_hours, :service_hours)
      end

      def services_requiring_service_standard_complete?
        service_question_complete_for_codes?(services_requiring_service_standards, :service_standard)
      end

      def service_question_complete_for_codes?(codes, context)
        procurement_building_services.where(code: codes).pluck(context).all?(&:present?)
      end

      MANDATORY_SERVICES = %w[M.1 N.1 O.1].freeze
    end
  end
end
