module FacilitiesManagement::Beta::ProcurementDirectAwardContractHelper
  include FacilitiesManagement::Beta::RequirementsHelper

  def warning_title
    if @procurement.procurement_closed
      'Closed'
    else
      WARNINGS[@procurement.aasm_state]
    end
  end

  def warning_message
    warning_messages = { awaiting_supplier_response: "This offer was sent to the supplier on #{format_date_time(@procurement.contract_sent_date)}.",
                         awaiting_contract_signature: 'Awaiting your confirmation of signed contract.',
                         accepted_and_signed: "You confirmed that the contract period is between #{format_date(@procurement.contract_start_date)} and #{format_date(@procurement.contract_end_date)}.",
                         accepted_not_signed: "You confirmed on the #{format_date_time @procurement.contract_not_signed_date} that the contract has not been signed.",
                         supplier_declined: "The supplier declined this offer #{format_date_time(@procurement.date_responded_to_contract)}.",
                         no_supplier_response: 'The supplier did not respond to your contract offer within the required 2 working days (48 hours).' }
    if @procurement.procurement_closed
      "This contract offer was closed on #{format_date_time(@procurement.date_contract_closed)}."
    else
      warning_messages[@procurement.aasm_state]
    end
  end

  WARNINGS = { awaiting_supplier_response: 'Sent', awaiting_contract_signature: 'Accepted, awaiting contract signature', accepted_and_signed: 'Accepted and signed', accepted_not_signed: 'Accepted, not signed', supplier_declined: 'Declined', no_supplier_response: 'Not responded' }.freeze
end