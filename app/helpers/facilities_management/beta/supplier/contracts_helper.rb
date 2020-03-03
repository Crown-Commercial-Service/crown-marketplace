module FacilitiesManagement::Beta::Supplier::ContractsHelper
  include FacilitiesManagement::Beta::ProcurementsHelper

  def warning_message
    warning_messages = { sent: "This contract offer expires on #{format_date_time(@contract.contract_expiry_date)}.",
                         accepted: 'Awaiting buyer confirmation of signed contract.',
                         signed: "Your contract starts on #{format_date(@contract.contract_start_date)} and ends on #{format_date(@contract.contract_end_date)}.",
                         declined: "You declined this contract offer on #{format_date_time(@contract.supplier_response_date)}.",
                         expired: "You did not respond to this contract offer within the required timescales,<br/> therefore it was automatically declined with the reason of 'no response'.",
                         not_signed: "The buyer has recorded this contract as 'not signed' on #{format_date_time(@contract.contract_closed_date)}. <br> The contract offer has therefore been closed.",
                         withdrawn: "The buyer withdrew this contract offer and closed this procurement on <br/> #{format_date_time(@contract.contract_closed_date)}." }
    warning_messages[@contract.aasm_state.to_sym]
  end

  WARNINGS = { sent: 'Received contract offer', accepted: 'Accepted', signed: 'Accepted and signed', declined: 'Declined', expired: 'Not responded', not_signed: 'Not signed', withdrawn: 'Withdrawn' }.freeze
end
