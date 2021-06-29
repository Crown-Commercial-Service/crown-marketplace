module FacilitiesManagement::PageDetail::Contracts
  include FacilitiesManagement::PageDetail

  def page_details(action)
    action = 'edit' if action == 'update'
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end

  def show_continuation_text
    case @contract.aasm_state
    when 'accepted'
      'Confirm if contract signed or not'
    when 'not_signed', 'declined', 'expired'
      "View next supplier's price"
    end
  end

  def show_secondary_text
    if @contract.closed? || @contract.aasm_state == 'signed'
      'Make a copy of your requirements'
    else
      'Close this procurement'
    end
  end

  def edit_secondary_text
    if params['name'] == 'next_supplier'
      'Cancel and return to contract summary'
    else
      'Cancel'
    end
  end

  def edit_page_title
    if params['name'] == 'next_supplier'
      'Offer to next supplier'
    else
      'Confirmation of signed contract'
    end
  end

  def page_definitions
    @page_definitions ||= {
      default: {
        back_label: 'Back',
        back_text: 'Back',
        back_url: facilities_management_procurements_path,
        caption1: @procurement.contract_name,
        return_text: 'Return to procurements dashboard',
        return_url: facilities_management_procurements_path,
      },
      show: {
        page_title: 'Contract summary',
        continuation_text: show_continuation_text,
        return_text: 'Return to procurements dashboard',
        secondary_text: show_secondary_text,
        back_text: 'Return to procurements dashboard',
      },
      edit: {
        back_url: facilities_management_procurement_contract_path(@procurement),
        page_title: edit_page_title,
        continuation_text: 'Close this procurement',
        secondary_text: edit_secondary_text,
      },
    }.freeze
  end
end
