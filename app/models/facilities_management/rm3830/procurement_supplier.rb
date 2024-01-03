module FacilitiesManagement
  module RM3830
    class ProcurementSupplier < ApplicationRecord
      include AASM
      include WorkingDays

      default_scope { order(direct_award_value: :asc) }
      belongs_to :procurement, class_name: 'FacilitiesManagement::RM3830::Procurement', foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement_suppliers
      belongs_to :supplier, inverse_of: :contracts, class_name: 'FacilitiesManagement::RM3830::SupplierDetail'

      has_one_attached :contract_documents_zip

      attribute :contract_response
      attribute :contract_signed
      attribute :reason_for_not_signing
      attribute :contract_start_date_dd
      attribute :contract_start_date_mm
      attribute :contract_start_date_yyyy
      attribute :contract_end_date_dd
      attribute :contract_end_date_mm
      attribute :contract_end_date_yyyy

      before_validation proc { convert_to_boolean('contract_response') }, on: :contract_response
      validates :contract_response, inclusion: { in: [true, false] }, on: :contract_response

      validates :reason_for_declining, presence: true, if: -> { contract_response == false }, on: :contract_response
      validate proc { text_area_max_length(:reason_for_declining, 500) }, if: -> { contract_response == false }, on: :contract_response

      validates :reason_for_closing, presence: true, on: :reason_for_closing
      validate proc { text_area_max_length(:reason_for_closing, 500) }, on: :reason_for_closing

      acts_as_gov_uk_date :contract_start_date, :contract_end_date, error_clash_behaviour: :omit_gov_uk_date_field_error

      before_validation proc { convert_to_boolean('contract_signed') }, on: :confirmation_of_signed_contract
      validates :contract_signed, inclusion: { in: [true, false] }, on: :confirmation_of_signed_contract

      validates :reason_for_not_signing, presence: true, if: -> { contract_signed == false }, on: :confirmation_of_signed_contract
      validate proc { text_area_max_length(:reason_for_not_signing, 100) }, if: -> { contract_signed == false }, on: :confirmation_of_signed_contract

      validate -> { valid_date?(:contract_start_date) }, unless: -> { contract_start_date_dd.empty? || contract_start_date_mm.empty? || contract_start_date_yyyy.empty? }, on: :confirmation_of_signed_contract
      validates :contract_start_date, presence: true, if: -> { contract_signed == true }, on: :confirmation_of_signed_contract
      validates :contract_start_date, date: { after_or_equal_to: proc { EARLIEST_CONTRACT_START_DATE } }, if: -> { contract_signed == true && real_date?(:contract_start_date) }, on: :confirmation_of_signed_contract

      validate -> { valid_date?(:contract_end_date) }, unless: -> { contract_end_date_dd.empty? || contract_end_date_mm.empty? || contract_end_date_yyyy.empty? }, on: :confirmation_of_signed_contract
      validates :contract_end_date, presence: true, if: -> { contract_signed == true }, on: :confirmation_of_signed_contract
      validates :contract_end_date, date: { after_or_equal_to: proc { :contract_start_date } }, if: -> { contract_signed == true && real_date?(:contract_start_date) }, on: :confirmation_of_signed_contract

      # rubocop:disable Metrics/BlockLength
      aasm do
        state :unsent, initial: true
        state :sent
        state :accepted
        state :signed
        state :not_signed
        state :withdrawn
        state :declined
        state :expired

        event :offer_to_supplier do
          before do
            assign_contract_number
            unset_contract_documents_zip_generated
            set_sent_date
            send_email_to_supplier('DA_offer_sent')
            GenerateContractZip.perform_in(1.minute, id)
            ChangeStateWorker.perform_at(time_delta_in_days(offer_sent_date, contract_expiry_date).from_now, id)
            ContractSentReminder.perform_at(time_delta_in_days(offer_sent_date, contract_reminder_date).from_now, id)
          end
          transitions from: :unsent, to: :sent
        end

        event :accept do
          before do
            set_supplier_response_date
            self.reason_for_declining = nil
            send_email_to_buyer('DA_offer_accepted')
            AwaitingSignatureReminder.perform_at(AWAITING_SIGNATURE_REMINDER_DAYS.days.from_now, id)
          end
          transitions from: :sent, to: :accepted
        end

        event :sign do
          before do
            set_contract_signed_date
            self.reason_for_not_signing = nil
            send_email_to_supplier('DA_offer_signed_contract_live')
          end
          transitions from: :accepted, to: :signed
        end

        event :not_sign do
          before do
            set_contract_signed_date
            self.contract_start_date = nil
            self.contract_end_date = nil
            send_email_to_supplier('DA_offer_accepted_not_signed')
          end
          transitions from: :accepted, to: :not_signed
        end

        event :withdraw do
          before do
            send_email_to_supplier('DA_offer_withdrawn')
          end
          transitions from: %i[accepted sent], to: :withdrawn
        end

        event :decline do
          before do
            set_supplier_response_date
            set_contract_closed_date
            send_email_to_buyer('DA_offer_declined')
          end
          transitions from: :sent, to: :declined
        end

        event :expire do
          before do
            set_supplier_response_date
            send_email_to_buyer('DA_offer_no_response')
          end
          transitions from: :sent, to: :expired
        end
      end

      # rubocop:enable Metrics/BlockLength
      def assign_contract_number
        self.contract_number = generate_contract_number
      end

      def closed?
        return true if procurement.aasm_state == 'closed'
        return false if unsent?

        procurement.procurement_suppliers.where.not(aasm_state: 'unsent')&.last&.id != id
      end

      SENT_OFFER_ORDER = %w[sent declined expired accepted not_signed].freeze

      CLOSED_TO_SUPPLIER = %w[declined expired withdrawn not_signed].freeze

      def contract_expiry_date
        WorkingDays.working_days(CONTRACT_EXPIRE_DAYS, offer_sent_date.to_datetime)
      end

      def contract_reminder_date
        WorkingDays.working_days(CONTRACT_REMINDER_DAYS, offer_sent_date.to_datetime)
      end

      def send_reminder_email_to_suppiler
        send_email_to_supplier('DA_offer_sent_reminder')
      end

      def send_reminder_email_to_buyer
        send_email_to_buyer('DA_offer_accepted_signature_confirmation_reminder')
      end

      def set_contract_closed_date
        self.contract_closed_date = DateTime.now.in_time_zone('London')
      end

      def unset_contract_documents_zip_generated
        self.contract_documents_zip_generated = false
      end

      def last_offer?
        return false unless procurement.procurement_suppliers.where(direct_award_value: Procurement::DIRECT_AWARD_VALUE_RANGE, aasm_state: %w[unsent sent]).empty?

        procurement.procurement_suppliers.where(direct_award_value: Procurement::DIRECT_AWARD_VALUE_RANGE).last == self
      end

      def supplier_email
        supplier.contact_email
      end

      delegate :supplier_name, to: :supplier

      def closed_date
        case aasm_state
        when 'not_signed'
          contract_signed_date
        when 'expired', 'declined'
          supplier_response_date
        else
          contract_closed_date
        end
      end

      def cannot_offer_to_next_supplier?
        procurement.closed? || sent? || accepted? || signed?
      end

      def cannot_withdraw?
        procurement.closed? || signed?
      end

      private

      EARLIEST_CONTRACT_START_DATE = DateTime.new(2020, 6, 1).in_time_zone('London').freeze

      # Custom Validation
      def real_date?(date)
        DateTime.valid_date? send(:"#{date}_yyyy").to_i, send(:"#{date}_mm").to_i, send(:"#{date}_dd").to_i
      end

      def valid_date?(date)
        errors.add(date, :not_a_date) unless real_date?(date)
      end

      def text_area_max_length(attribute, maximum)
        errors.add(attribute, :too_long) if self[attribute].present? && self[attribute].gsub("\r\n", "\r").length > maximum
      end

      def time_delta_in_days(start_date, end_date)
        (end_date - start_date.to_datetime).to_f.days
      end

      CONTRACT_REMINDER_DAYS = 1
      CONTRACT_EXPIRE_DAYS = 2
      AWAITING_SIGNATURE_REMINDER_DAYS = 14

      def convert_to_boolean(contract_boolean)
        send("#{contract_boolean}=", ActiveModel::Type::Boolean.new.cast(send(contract_boolean)))
      end

      def generate_contract_number
        return unless procurement.further_competition? || procurement.direct_award? || procurement.da_draft?

        procurement_state = procurement.direct_award? || procurement.da_draft? ? :direct_award : :further_competition

        ContractNumberGenerator.new(procurement_state: procurement_state, framework: 'RM3830', model: self.class).new_number
      end

      def set_sent_date
        self.offer_sent_date = DateTime.now.in_time_zone('London')
      end

      def set_supplier_response_date
        self.supplier_response_date = DateTime.now.in_time_zone('London')
      end

      def set_contract_signed_date
        self.contract_signed_date = DateTime.now.in_time_zone('London')
      end

      def format_date_time_numeric(date)
        date&.in_time_zone('London')&.strftime '%d/%m/%Y, %l:%M%P'
      end

      def format_date(date)
        date&.in_time_zone('London')&.strftime '%d/%m/%Y'
      end

      def send_email_to_buyer(template_name)
        gov_notify_template_arg = {
          'da-offer-1-supplier-1': supplier_name,
          'da-offer-1-buyer-1': procurement.user.buyer_detail.organisation_name,
          'da-offer-1-reference': contract_number,
          'da-offer-1-name': procurement.contract_name,
          'da-offer-1-decline-reason': reason_for_declining,
          'da-offer-1-accept-date': format_date_time_numeric(supplier_response_date),
          'da-offer-1-link': "#{Marketplace.rails_env_url}/facilities-management/RM3830/procurements/#{procurement.id}/contracts/#{id}"
        }.to_json

        GovNotifyNotification.perform_async(template_name, procurement.user.email, gov_notify_template_arg)
      end

      def send_email_to_supplier(template_name)
        gov_notify_template_arg = {
          'da-offer-1-buyer-1': procurement.user.buyer_detail.organisation_name,
          'da-offer-1-name': procurement.contract_name,
          'da-offer-1-expiry': format_date_time_numeric(contract_expiry_date),
          'da-offer-1-link': "#{Marketplace.rails_env_url}/facilities-management/RM3830/supplier/contracts/#{id}",
          'da-offer-1-supplier-1': supplier_name,
          'da-offer-1-reference': contract_number,
          'da-offer-1-not-signed-reason': reason_for_not_signing,
          'da-offer-1-contract-start-date': format_date(contract_start_date),
          'da-offer-1-contract-end-date': format_date(contract_end_date),
          'da-offer-1-withdrawal-reason': reason_for_closing
        }.to_json

        GovNotifyNotification.perform_async(template_name, supplier_email, gov_notify_template_arg)
      end
    end
  end
end
