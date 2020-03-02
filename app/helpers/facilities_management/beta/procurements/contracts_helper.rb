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
end
