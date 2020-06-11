module FacilitiesManagement::Supplier::ContractsHelper
  include FacilitiesManagement::ProcurementsHelper

  def warning_message
    warning_messages = { sent: "This contract offer expires on #{format_date_time(@contract.contract_expiry_date)}. <br/> The buyer is waiting for a response before the offer expiry deadline shown above.",
                         accepted: 'Awaiting buyer confirmation of signed contract.',
                         signed: "The buyer confirmed that the contract period is between #{format_date(@contract.contract_start_date)} and #{format_date(@contract.contract_end_date)}.",
                         declined: "You declined this contract offer on #{format_date_time(@contract.supplier_response_date)}.",
                         expired: "You did not respond to this contract offer within the required timescales,<br/> therefore it was automatically declined with the reason of 'no response'.",
                         not_signed: "The buyer has recorded this contract as 'not signed' on #{format_date_time(@contract.contract_signed_date)}. <br> The contract offer has therefore been closed.",
                         withdrawn: "The buyer withdrew this contract offer and closed this procurement on <br/> #{format_date_time(@contract.contract_closed_date)}." }
    warning_messages[@contract.aasm_state.to_sym]
  end

  WARNINGS = { sent: 'Received contract offer',
               accepted: 'Accepted',
               signed: 'Accepted and signed',
               declined: 'Declined',
               expired: 'Not responded',
               not_signed: 'Not signed',
               withdrawn: 'Withdrawn' }.freeze

  def page_details(action)
    action = 'edit' if action == 'update'
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end

  def page_definitions
    @page_definitions ||= {
      default: {
      },
      show: {
        back_url: facilities_management_supplier_dashboard_index_path,
        back_label: 'Back',
        back_text: 'Back',
        page_title: 'Contract summary',
        caption1: @procurement.contract_name,
        continuation_text: 'Respond to this offer',
        secondary_text: 'Return to dashboard',
        secondary_url: facilities_management_supplier_dashboard_index_path,
        return_text: 'Return to dashboard',
        return_url: facilities_management_supplier_dashboard_index_path
      },
      edit: {
        back_url: facilities_management_supplier_contract_path(@contract.id),
        back_label: 'Back',
        back_text: 'Back',
        page_title: 'Respond to the contract offer',
        caption1: @procurement.contract_name,
        continuation_text: 'Confirm and continue',
        secondary_text: 'Cancel',
        secondary_url: facilities_management_supplier_dashboard_index_path
      }
    }.freeze
  end
end
