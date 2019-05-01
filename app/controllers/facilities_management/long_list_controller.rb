require 'json'
require 'facilities_management/fm_supplier_data'
require 'transient_session_info'

# Rails.config.xxx = 123
# config.user ||= {}
# session.id
class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :long_list

  def long_list
    @select_fm_locations = '/facilities-management/select-locations'
    @select_fm_services = '/facilities-management/select-services'
    @posted_locations = JSON.parse(params[:postedlocations])
    @posted_services = JSON.parse(params[:postedservices])
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'You must select at least one region and one service before clicking the continue button'
    @locations = '(' + @posted_locations.map { |x| "'\"#{x}\"'" }.join(',') + ')'
    @services = '(' + @posted_services.map { |x| "'\"#{x}\"'" }.join(',') + ')'

    fm_supplier_data = FMSupplierData.new
    @supplier_count = fm_supplier_data.long_list_supplier_count(@locations, @services)
    @suppliers_lot1a = fm_supplier_data.long_list_suppliers_lot(@locations, @services, '1a')
    @suppliers_lot1b = fm_supplier_data.long_list_suppliers_lot(@locations, @services, '1b')
    @suppliers_lot1c = fm_supplier_data.long_list_suppliers_lot(@locations, @services, '1c')

    transient_session_info
  end

  private

  def transient_session_info
    TransientSessionInfo.tsi[session.id, :posted_locations] = @posted_locations
    TransientSessionInfo.tsi[session.id, :posted_services] = @posted_services
    TransientSessionInfo.tsi[session.id, :locations] = @locations
    TransientSessionInfo.tsi[session.id, :services] = @services
  end
end
