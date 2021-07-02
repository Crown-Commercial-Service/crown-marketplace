module FacilitiesManagement::PageDetail::RM3830::Supplier::Contracts
  include FacilitiesManagement::PageDetail

  def page_details(action)
    action = 'edit' if action == 'update'
    @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
  end

  def page_definitions
    @page_definitions ||= {
      default: {
      },
      show: {
        back_url: facilities_management_rm3830_supplier_dashboard_index_path,
        back_label: 'Return to dashboard',
        back_text: 'Return to dashboard',
        page_title: 'Contract summary',
        caption1: @procurement.contract_name,
        continuation_text: 'Respond to this offer',
        secondary_text: 'Return to dashboard',
        secondary_url: facilities_management_rm3830_supplier_dashboard_index_path,
        return_text: 'Return to dashboard',
        return_url: facilities_management_rm3830_supplier_dashboard_index_path
      },
      edit: {
        back_url: facilities_management_rm3830_supplier_contract_path(@contract.id),
        back_label: 'Return to contract summary',
        back_text: 'Return to contract summary',
        page_title: 'Respond to the contract offer',
        caption1: @procurement.contract_name,
        continuation_text: 'Confirm and continue',
        secondary_text: 'Cancel',
        secondary_url: facilities_management_rm3830_supplier_dashboard_index_path
      }
    }.freeze
  end
end
