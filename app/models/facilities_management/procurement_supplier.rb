module FacilitiesManagement
  class ProcurementSupplier < ApplicationRecord
    include AASM

    default_scope { order(direct_award_value: :asc) }
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_suppliers

    attribute :contract_response
    attribute :contract_signed
    attribute :reason_for_not_signing
    attribute :contract_start_date_dd
    attribute :contract_start_date_mm
    attribute :contract_start_date_yyyy
    attribute :contract_end_date_dd
    attribute :contract_end_date_mm
    attribute :contract_end_date_yyyy

    acts_as_gov_uk_date :contract_start_date, :contract_end_date, error_clash_behaviour: :omit_gov_uk_date_field_error

    before_validation :supplier_convert_to_boolean, on: :contract_response
    validates :contract_response, inclusion: { in: [true, false] }, on: :contract_response
    validates :reason_for_declining, presence: true, length: 1..500, if: :contract_response_false?, on: :contract_response
    validates :reason_for_closing, length: { maximum: 500 }, presence: true, on: :reason_for_closing

    before_validation :buyer_convert_to_boolean, on: :confirmation_of_signed_contract
    validates :contract_signed, inclusion: { in: [true, false] }, on: :confirmation_of_signed_contract
    validates :reason_for_not_signing, presence: true, length: 1..100, if: :contract_signed_false?, on: :confirmation_of_signed_contract
    validates :contract_start_date, presence: true, if: :contract_signed_true?, on: :confirmation_of_signed_contract
    validates :contract_end_date, presence: true, if: :contract_signed_true?, on: :confirmation_of_signed_contract
    validates :contract_end_date, date: { allow_nil: false, after_or_equal_to: proc { :contract_start_date } }, if: :contract_signed_true?, on: :confirmation_of_signed_contract

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
          set_sent_date
          send_email_to_supplier('DA_offer_sent')
        end
        transitions from: :unsent, to: :sent
      end

      event :accept do
        before do
          set_supplier_response_date
          send_email_to_buyer('DA_offer_accepted')
        end
        transitions from: :sent, to: :accepted
      end

      event :sign do
        transitions from: :accepted, to: :signed
      end

      event :not_sign do
        transitions from: :accepted, to: :not_signed
      end

      event :withdraw do
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
        transitions from: :sent, to: :expired
      end
    end
    # rubocop:enable Metrics/BlockLength

    def self.used_direct_award_contract_numbers_for_current_year
      where('contract_number like ?', 'RM3860-DA%')
        .where('contract_number like ?', "%-#{Date.current.year}")
        .pluck(:contract_number)
        .map { |contract_number| contract_number.split('-')[1].split('DA')[1] }
    end

    def self.used_further_competition_contract_numbers_for_current_year
      where('contract_number like ?', 'RM3860-FC%')
        .where('contract_number like ?', "%-#{Date.current.year}")
        .pluck(:contract_number)
        .map { |contract_number| contract_number.split('-')[1].split('FC')[1] }
    end

    def supplier
      CCS::FM::Supplier.find(supplier_id)
    end

    def assign_contract_number
      self.contract_number = generate_contract_number
    end

    def closed?
      return true if procurement.aasm_state == 'closed'
      return false if aasm_state == 'unsent'

      procurement.procurement_suppliers.where.not(aasm_state: 'unsent')&.last&.id != id
    end

    SENT_OFFER_ORDER = %i[sent declined expired accepted not_signed].freeze

    CLOSED_TO_SUPPLIER = %w[declined expired withdrawn not_signed].freeze

    def contract_expiry_date
      offer_sent_date + 2.days # This needs to be change later so that it doesnt take in account weekend
    end

    private

    def contract_response_false?
      contract_response == false
    end

    def contract_signed_false?
      contract_signed == false
    end

    def contract_signed_true?
      contract_signed == true
    end

    def buyer_convert_to_boolean
      self.contract_signed = ActiveModel::Type::Boolean.new.cast(contract_signed)
    end

    def supplier_convert_to_boolean
      self.contract_response = ActiveModel::Type::Boolean.new.cast(contract_response)
    end

    def generate_contract_number
      return unless procurement.further_competition? || procurement.direct_award?

      return ContractNumberGenerator.new(procurement_state: :direct_award, used_numbers: self.class.used_direct_award_contract_numbers_for_current_year).new_number if procurement.direct_award?

      ContractNumberGenerator.new(procurement_state: :further_competition, used_numbers: self.class.used_further_competition_contract_numbers_for_current_year).new_number
    end

    def set_sent_date
      self.offer_sent_date = DateTime.now.in_time_zone('London')
    end

    def set_contract_closed_date
      self.contract_closed_date = DateTime.now.in_time_zone('London')
    end

    def set_supplier_response_date
      self.supplier_response_date = DateTime.now.in_time_zone('London')
    end

    def format_date_time_numeric(date)
      date.strftime '%d/%m/%Y, %l:%M%P'
    end

    def host
      case ENV['RAILS_ENV']
      when 'production'
        'https://cmp.cmpdev.crowncommercial.gov.uk'
      when 'development'
        'http://localhost:3000'
      end
    end

    # rubocop:disable Metrics/AbcSize
    def send_email_to_buyer(email_type)
      template_name = email_type
      email_to = procurement.user.email

      gov_notify_template_arg = {
        'da-offer-1-supplier-1': supplier.data['supplier_name'],
        'da-offer-1-buyer-1': procurement.user.buyer_detail.organisation_name,
        'da-offer-1-reference': contract_number,
        'da-offer-1-name': procurement.contract_name,
        'da-offer-1-decline-reason': reason_for_declining,
        'da-offer-1-accept-date': format_date_time_numeric(supplier_response_date),
        'da-offer-1-link': host + '/facilities-management/beta/procurements/' + procurement.id + '/contracts/' + id
      }.to_json

      FacilitiesManagement::GovNotifyNotification.perform_async(template_name, email_to, gov_notify_template_arg)
    end
    # rubocop:enable Metrics/AbcSize

    def send_email_to_supplier(email_type)
      template_name = email_type
      email_to = supplier.data['contact_email']

      gov_notify_template_arg = {
        'da-offer-1-buyer-1': procurement.user.buyer_detail.organisation_name,
        'da-offer-1-name': procurement.contract_name,
        'da-offer-1-expiry': format_date_time_numeric(contract_expiry_date),
        'da-offer-1-link': host + '/facilities-management/beta/supplier/contracts/' + id,
        'da-offer-1-supplier-1': supplier.data['supplier_name'],
        'da-offer-1-reference': contract_number
      }.to_json

      FacilitiesManagement::GovNotifyNotification.perform_async(template_name, email_to, gov_notify_template_arg)
    end
  end
end
