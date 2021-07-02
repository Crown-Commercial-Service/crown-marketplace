module FacilitiesManagement::Procurements::ContractsHelper
  include FacilitiesManagement::ProcurementsHelper

  def warning_title
    if @contract.closed?
      'Closed'
    else
      WARNINGS[@contract.aasm_state.to_sym]
    end
  end

  # rubocop:disable Metrics/AbcSize
  def warning_message
    warning_messages = { sent: "#{t('facilities_management.procurements.contracts_helper.warning_message.sent_1')} #{format_date_time(@contract.contract_expiry_date)}.<br/> #{t('facilities_management.procurements.contracts_helper.warning_message.sent_2')}",
                         accepted: t('facilities_management.procurements.contracts_helper.warning_message.accepted'),
                         signed: "#{t('facilities_management.procurements.contracts_helper.warning_message.signed')} #{format_date(@contract.contract_start_date)} and #{format_date(@contract.contract_end_date)}.",
                         not_signed: "#{t('facilities_management.procurements.contracts_helper.warning_message.not_signed_1')} #{format_date_time @contract.contract_signed_date} #{t('facilities_management.procurements.contracts_helper.warning_message.not_signed_2')}.",
                         declined: "#{t('facilities_management.procurements.contracts_helper.warning_message.declined')} #{format_date_time(@contract.supplier_response_date)}.",
                         expired: t('facilities_management.procurements.contracts_helper.warning_message.expired') }
    if @contract.closed?
      if !@contract.reason_for_closing.nil?
        "#{t('facilities_management.procurements.contracts_helper.warning_message.closed')} #{format_date_time(@contract.contract_closed_date)}."
      elsif @contract.last_offer?
        "#{t('facilities_management.procurements.contracts_helper.warning_message.last_closed_1')} #{format_date_time(@contract.contract_closed_date)} #{t('facilities_management.procurements.contracts_helper.warning_message.last_closed_2')}"
      else
        "#{t('facilities_management.procurements.contracts_helper.warning_message.last_closed_3')} #{format_date_time(@contract.contract_closed_date)}."
      end
    else
      warning_messages[@contract.aasm_state.to_sym]
    end
  end
  # rubocop:enable Metrics/AbcSize

  WARNINGS = { sent: 'Sent',
               accepted: 'Accepted, awaiting contract signature',
               signed: 'Accepted and signed',
               not_signed: 'Accepted, not signed',
               declined: 'Declined',
               expired: 'Not responded' }.freeze
end
