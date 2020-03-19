module FacilitiesManagement::Beta::Procurements::ContractsHelper
  include FacilitiesManagement::Beta::ProcurementsHelper

  def warning_title
    if @contract.closed?
      'Closed'
    else
      WARNINGS[@contract.aasm_state.to_sym]
    end
  end

  def warning_message
    warning_messages = { sent: "#{t('facilities_management.beta.procurements.contracts_helper.warning_message.sent')} #{format_date_time(@contract.offer_sent_date)}.",
                         accepted: t('facilities_management.beta.procurements.contracts_helper.warning_message.accepted'),
                         signed: "#{t('facilities_management.beta.procurements.contracts_helper.warning_message.signed')} #{format_date(@contract.contract_start_date)} and #{format_date(@contract.contract_end_date)}.",
                         not_signed: "#{t('facilities_management.beta.procurements.contracts_helper.warning_message.not_signed_1')} #{format_date_time @contract.contract_signed_date} #{t('facilities_management.beta.procurements.contracts_helper.warning_message.not_signed_2')}.",
                         declined: "#{t('facilities_management.beta.procurements.contracts_helper.warning_message.declined')} #{format_date_time(@contract.supplier_response_date)}.",
                         expired: t('facilities_management.beta.procurements.contracts_helper.warning_message.expired') }
    if @contract.closed?
      "#{t('facilities_management.beta.procurements.contracts_helper.warning_message.closed')} #{format_date_time(@contract.contract_closed_date)}."
    else
      warning_messages[@contract.aasm_state.to_sym]
    end
  end

  WARNINGS = { sent: 'Sent',
               accepted: 'Accepted, awaiting contract signature',
               signed: 'Accepted and signed',
               not_signed: 'Accepted, not signed',
               declined: 'Declined',
               expired: 'Not responded' }.freeze

  def page_details(action)
    action = 'edit' if action == 'update'
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end

  def set_continuation_text
    case @contract.aasm_state
    when 'accepted'
      'Confirm if contract signed or not'
    when 'not_signed', 'declined', 'expired'
      "View next supplier's price"
    end
  end

  def set_secondary_text
    if @contract.closed? || @contract.aasm_state == 'signed'
      'Make a copy of your requirements'
    else
      'Close this procurement'
    end
  end

  def page_definitions
    @page_definitions ||= {
      default: {
        back_label: 'Back',
        back_text: 'Back',
        back_url: facilities_management_beta_procurements_path,
        return_text: 'Return to procurements dashboard',
        return_url: facilities_management_beta_procurements_path,
      },
      show: {
        page_title: 'Contract summary',
        caption1: @procurement.contract_name,
        continuation_text: set_continuation_text,
        return_text: 'Return to procurements dashboard',
        secondary_text: set_secondary_text,
      },
      edit: {
        back_url: facilities_management_beta_procurement_contract_path(@procurement),
        continuation_text: 'Close this procurement',
        secondary_text: 'Cancel',
      },
    }.freeze
  end
end
