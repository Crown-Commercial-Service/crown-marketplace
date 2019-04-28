require 'json'
require 'facilities_management/fm_supplier_data'
require 'transient_session_info'

class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :long_list

  def long_list
    @select_fm_locations = '/facilities-management/select-locations'
    @select_fm_services = '/facilities-management/select-services'
    $tsi[session.id, :posted_locations] = @posted_locations = JSON.parse(params[:postedlocations])
    $tsi[session.id, :posted_services] = @posted_services = JSON.parse(params[:postedservices])
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'You must select at least one longList before clicking the save continue button'
    locations = '(' + @posted_locations.map { |x| "'\"#{x}\"'" }.join(',') + ')'
    services = '(' + @posted_services.map { |x| "'\"#{x}\"'" }.join(',') + ')'
    fm_supplier_data = FMSupplierData.new
    $tsi[session.id, :supplier_count] = @supplier_count = fm_supplier_data.long_list_supplier_count(locations, services)
    $tsi[session.id, :suppliers_lot1a] = @suppliers_lot1a = fm_supplier_data.long_list_suppliers_lot(locations, services, '1a')
    $tsi[session.id, :suppliers_lot1b] = @suppliers_lot1b = fm_supplier_data.long_list_suppliers_lot(locations, services, '1b')
    $tsi[session.id, :suppliers_lot1c] = @suppliers_lot1c = fm_supplier_data.long_list_suppliers_lot(locations, services, '1c')
  end
end
