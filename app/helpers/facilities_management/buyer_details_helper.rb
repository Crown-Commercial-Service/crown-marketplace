module FacilitiesManagement::BuyerDetailsHelper
  def object_name(name)
    name
  end

  def cant_find_address_link
    facilities_management_buyer_detail_edit_address_path(@buyer_detail, update_address: true)
  end
end
