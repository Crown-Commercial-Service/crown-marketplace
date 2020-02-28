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
    warning_messages = { sent: "This offer was sent to the supplier on #{format_date_time(@contract.offer_sent_date)}.",
                         accepted: 'Awaiting your confirmation of signed contract.',
                         signed: "You confirmed that the contract period is between #{format_date(@contract.contract_start_date)} and #{format_date(@contract.contract_end_date)}.",
                         not_signed: "You confirmed on the #{format_date_time @contract.contract_signed_date} that the contract has not been signed.",
                         declined: "The supplier declined this offer #{format_date_time(@contract.supplier_response_date)}.",
                         expired: 'The supplier did not respond to your contract offer within the required 2 working days (48 hours).' }
    if @contract.closed?
      "This contract offer was closed on #{format_date_time(@contract.contract_closed_date)}."
    else
      warning_messages[@contract.aasm_state.to_sym]
    end
  end

  WARNINGS = { sent: 'Sent', accepted: 'Accepted, awaiting contract signature', signed: 'Accepted and signed', not_signed: 'Accepted, not signed', declined: 'Declined', expired: 'Not responded' }.freeze
end
