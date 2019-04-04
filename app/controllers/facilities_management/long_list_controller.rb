require 'json'
require 'facilities_management/fm_supplier_data'
class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :long_list
  def long_list
    @select_fm_locations = '/facilities-management/select-locations'
    @select_fm_services = '/facilities-management/select-services'
    @posted_locations = JSON.parse(params[:postedlocations])
    @posted_services = JSON.parse(params[:postedservices])
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'You must select at least one longList before clicking the save continue button'
    locations = @posted_locations.to_s.tr('"', "'").sub('[', '(').sub(']', ')')
    services = @posted_services.to_s.tr('"', "'").sub('[', '(').sub(']', ')')
    locations2 = '(' + @posted_locations.map { |x| "'\"#{x}\"'" }.join(',') + ')'
    services2 = '(' + @posted_services.map { |x| "'\"#{x}\"'" }.join(',') + ')'
    puts locations
    puts services
    fm_supplier_data = FMSupplierData.new
    @supplier_count = fm_supplier_data.long_list_supplier_count(locations2, services2)
    @suppliers_lot1a = fm_supplier_data.long_list_suppliers_lot(locations2, services2, '1a')
    @suppliers_lot1b = fm_supplier_data.long_list_suppliers_lot(locations2, services2, '1b')
    @suppliers_lot1c = fm_supplier_data.long_list_suppliers_lot(locations2, services2, '1c')
  end
end
