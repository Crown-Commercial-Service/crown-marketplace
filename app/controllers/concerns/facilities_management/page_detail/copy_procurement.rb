module FacilitiesManagement::PageDetail::CopyProcurement
  include FacilitiesManagement::PageDetail

  def page_details(*)
    @page_details ||= page_definitions[:default].merge(page_definitions[:new])
  end

  def page_definitions
    @page_definitions ||= {
      default: {},
      new: {
        page_title: 'Create a copy',
        caption1: @procurement.contract_name,
        continuation_text: 'Save and continue',
        secondary_text: 'Cancel',
        secondary_url: page_back_url,
        back_text: 'Back',
        back_name: 'Back',
        back_url: page_back_url
      },
    }.freeze
  end

  private

  def find_contract_id
    return nil if params[:contract_id].nil?

    params[:contract_id].instance_of?(String) ? params[:contract_id] : params[:contract_id].keys.first
  end

  def page_back_url
    @contract.nil? ? facilities_management_procurement_path(id: @procurement.id) : facilities_management_procurement_contract_path(procurement_id: @procurement.id, id: find_contract_id)
  end
end
