module FacilitiesManagement::Beta::ProcurementDirectAwardContractHelper
  include FacilitiesManagement::Beta::RequirementsHelper

  def warning_title
    if @page_data[:procurement_data][:closed]
      'Closed'
    else
      WARNINGS.each { |status, text| return text if @page_data[:procurement_data][:aasm_state] == status }
    end
  end

  def warning_message
    warning_messages = { awaiting_supplier_response: "This offer was sent to the supplier on #{format_date_time(@page_data[:procurement_data][:contract_sent_date])}.",
                         awaiting_contract_signature: 'Awaiting your confirmation of signed contract.',
                         accepted_and_signed: "You confirmed that the contract period is between #{format_date(@page_data[:procurement_data][:contract_start_date])} and #{format_date(@page_data[:procurement_data][:contract_end_date])}.",
                         accepted_not_signed: "You confirmed on the #{format_date_time@page_data[:procurement_data][:contract_not_signed_date]} that the contract has not been signed.",
                         supplier_declined: "The supplier declined this offer #{format_date_time(@page_data[:procurement_data][:date_contract_declined])}.",
                         no_supplier_response: 'The supplier did not respond to your contract offer within the required 2 working days (48 hours).' }
    if @page_data[:procurement_data][:closed]
      "This contract offer was closed on #{format_date_time(@page_data[:procurement_data][:date_contract_closed])}."
    else
      warning_messages.each { |status, text| return text if @page_data[:procurement_data][:aasm_state] == status }
    end
  end

  WARNINGS = { awaiting_supplier_response: 'Sent', awaiting_contract_signature: 'Accepted, awaiting contract signature', accepted_and_signed: 'Accepted and signed', accepted_not_signed: 'Accepted, not signed', supplier_declined: 'Declined', no_supplier_response: 'Not responded' }.freeze
end
