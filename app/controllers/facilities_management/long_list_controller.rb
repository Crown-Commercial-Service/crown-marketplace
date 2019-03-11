require 'json'
require 'facilities_management/fm_supplier_data'
class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :long_list

  def long_list
    @select_fm_locations = '/facilities-management/select-locations'
    @select_fm_services = '/facilities-management/select-services'
    @posted_locations = JSON.parse(params[:postedlocations])
    @posted_services = JSON.parse(params[:postedservices])
    # making the param string sql friendly
    locations = @posted_locations.to_s.tr('"', "'").sub('[', '(').sub(']', ')')
    services = @posted_services.to_s.tr('"', "'").sub('[', '(').sub(']', ')')
    fm_supplier_data = FMSupplierData.new
    @supplier_count = fm_supplier_data.long_list_supplier_count(locations, services)
    @suppliers_lot1a = fm_supplier_data.long_list_suppliers_lot1a(locations, services)
    @suppliers_lot1b = fm_supplier_data.long_list_suppliers_lot1b(locations, services)
    @suppliers_lot1c = fm_supplier_data.long_list_suppliers_lot1c(locations, services)
  end
end
