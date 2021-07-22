module FacilitiesManagement::Procurements::ContractsHelper
  include FacilitiesManagement::ProcurementsHelper

  def warning_title
    if @contract.closed?
      t('closed', scope: TITLE_TRANSLATION_SCOPE)
    else
      t(@contract.aasm_state, scope: TITLE_TRANSLATION_SCOPE)
    end
  end

  def warning_message
    return closed_warning_message if @contract.closed?

    case @contract.aasm_state
    when 'sent'
      t('sent_html', scope: MESSAGE_TRANSLATION_SCOPE, contract_expiry_date: format_date_time(@contract.contract_expiry_date))
    when 'signed'
      t('signed', scope: MESSAGE_TRANSLATION_SCOPE, contract_start_date: format_date(@contract.contract_start_date), contract_end_date: format_date(@contract.contract_end_date))
    when 'not_signed'
      t('not_signed', scope: MESSAGE_TRANSLATION_SCOPE, contract_not_signed_date: format_date_time(@contract.contract_signed_date))
    when 'declined'
      t('declined', scope: MESSAGE_TRANSLATION_SCOPE, supplier_response_date: format_date_time(@contract.supplier_response_date))
    else
      t(@contract.aasm_state, scope: MESSAGE_TRANSLATION_SCOPE)
    end
  end

  def closed_warning_message
    if @contract.reason_for_closing.present?
      t('withdrawn', scope: MESSAGE_TRANSLATION_SCOPE, contract_closed_date: format_date_time(@contract.contract_closed_date))
    elsif @contract.last_offer?
      t('last_offer', scope: MESSAGE_TRANSLATION_SCOPE, contract_closed_date: format_date_time(@contract.contract_closed_date))
    else
      t('closed', scope: MESSAGE_TRANSLATION_SCOPE, contract_closed_date: format_date_time(@contract.contract_closed_date))
    end
  end

  MESSAGE_TRANSLATION_SCOPE = 'facilities_management.procurements.contracts_helper.warning_message'.freeze
  TITLE_TRANSLATION_SCOPE = 'facilities_management.procurements.contracts_helper.warning_title'.freeze
end
