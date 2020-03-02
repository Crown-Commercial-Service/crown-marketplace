module FacilitiesManagement
  class ProcurementSupplier < ApplicationRecord
    include AASM

    default_scope { order(direct_award_value: :asc) }
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_suppliers

    aasm do
      state :unsent, initial: true
      state :sent, before_enter: %i[assign_contract_number set_date_and_send_email]
      state :accepted, before_enter: %i[set_date_and_send_supplier_response]
      state :signed
      state :not_signed
      state :withdrawn
      state :declined
      state :expired

      event :offer_to_supplier do
        transitions from: :unsent, to: :sent
      end

      event :accept do
        transitions from: :sent, to: :accepted
      end

      event :sign do
        transitions from: :accepted, to: :signed
      end

      event :not_sign do
        transitions from: :accepted, to: :not_signed
      end

      event :withdraw do
        transitions from: :accepted, to: :withdrawn
      end

      event :decline do
        transitions from: :sent, to: :declined
      end

      event :expire do
        transitions from: :sent, to: :expired
      end
    end

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

    def generate_contract_number
      return unless procurement.further_competition? || procurement.direct_award?

      return ContractNumberGenerator.new(procurement_state: :direct_award, used_numbers: self.class.used_direct_award_contract_numbers_for_current_year).new_number if procurement.direct_award?

      ContractNumberGenerator.new(procurement_state: :further_competition, used_numbers: self.class.used_further_competition_contract_numbers_for_current_year).new_number
    end

    def set_date_and_send_email
      self.offer_sent_date = DateTime.now.in_time_zone('London')
      # send_offer_email
    end

    def set_date_and_send_supplier_response
      self.supplier_response_date = DateTime.now.in_time_zone('London')
    end

    def format_date_time_numeric
      contract_expiry_date&.strftime '%d/%m/%Y, %l:%M%P'
    end

    def send_offer_email
      template_name = 'DA_offer_sent'
      email_to = supplier.data['contact_email']
      gov_notify_template_arg = {
        'da-offer-1-buyer-1': procurement.user.buyer_detail.organisation_name,
        'da-offer-1-name': procurement.contract_name,
        'da-offer-1-expiry': format_date_time_numeric,
        'da-offer-1-link': 'www.google.com', # revist later when supplier is updated
        'da-offer-1-supplier-1': supplier.data['supplier_name'],
        'da-offer-1-reference': contract_number
      }.to_json

      FacilitiesManagement::GovNotifyNotification.perform_async(template_name, email_to, gov_notify_template_arg)
    end
  end
end
