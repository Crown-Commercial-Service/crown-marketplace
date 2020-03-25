module FacilitiesManagement::Beta::Procurements::CopyProcurementHelper
  include FacilitiesManagement::Beta::ProcurementsHelper

  def page_details(*)
    @page_details ||= page_definitions[:default].merge(page_definitions[:new])
  end

  def page_definitions
    @page_definitions ||= {
      default: {},
      new: {
        page_title: 'Create a copy',
        caption1: @procurement.contract_name,
        continuation_text: 'Save and contiue',
        secondary_text: 'Cancel',
        secondary_url: facilities_management_beta_procurement_contract_path(procurement_id: @procurement.id, id: @contract.id),
        back_text: 'Back',
        back_name: 'Back',
        back_url: facilities_management_beta_procurement_contract_path(procurement_id: @procurement.id, id: @contract.id)
      },
    }.freeze
  end
end
