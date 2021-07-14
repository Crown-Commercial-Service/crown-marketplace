module FacilitiesManagement::RM3830::Supplier::ContractsHelper
  include FacilitiesManagement::RM3830::ProcurementsHelper

  def warning_title
    t(@contract.aasm_state, scope: TITLE_TRANSLATION_SCOPE)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def warning_message
    case @contract.aasm_state
    when 'sent'
      t('sent_html', scope: MESSAGE_TRANSLATION_SCOPE, contract_expiry_date: format_date_time(@contract.contract_expiry_date))
    when 'accepted'
      t('accepted', scope: MESSAGE_TRANSLATION_SCOPE)
    when 'signed'
      t('signed', scope: MESSAGE_TRANSLATION_SCOPE, contract_start_date: format_date(@contract.contract_start_date), contract_end_date: format_date(@contract.contract_end_date))
    when 'declined'
      t('declined', scope: MESSAGE_TRANSLATION_SCOPE, supplier_response_date: format_date_time(@contract.supplier_response_date))
    when 'expired'
      t('expired_html', scope: MESSAGE_TRANSLATION_SCOPE)
    when 'not_signed'
      t('not_signed_html', scope: MESSAGE_TRANSLATION_SCOPE, contract_not_signed_date: format_date_time(@contract.contract_signed_date))
    when 'withdrawn'
      t('withdrawn_html', scope: MESSAGE_TRANSLATION_SCOPE, contract_closed_date: format_date_time(@contract.contract_closed_date))
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  MESSAGE_TRANSLATION_SCOPE = 'facilities_management.rm3830.supplier.contracts_helper.warning_message'.freeze
  TITLE_TRANSLATION_SCOPE = 'facilities_management.rm3830.supplier.contracts_helper.warning_title'.freeze

  def supplier_contract_reason_id(state)
    case state
    when 'not_signed'
      'reason-for-not-signing'
    when 'declined'
      'reason-for-declining'
    when 'withdrawn'
      'reason-for-closing'
    else
      'no-reason-required'
    end
  end
end
