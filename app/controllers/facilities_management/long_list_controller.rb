require 'json'
require 'facilities_management/fm_supplier_data'
require 'transient_session_info'

# Rails.config.xxx = 123
# config.user ||= {}
# session.id
class FacilitiesManagement::LongListController < ApplicationController
  before_action :authenticate_user!, only: :long_list
  before_action :authorize_user, only: :long_list

  # rubocop:disable Metrics/AbcSize
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

    @suppliers_lot1a  = CCS::FM::Supplier.long_list_suppliers_lot(@posted_locations, @posted_services, '1a')
    @suppliers_lot1b  = CCS::FM::Supplier.long_list_suppliers_lot(@posted_locations, @posted_services, '1b')
    @suppliers_lot1c  = CCS::FM::Supplier.long_list_suppliers_lot(@posted_locations, @posted_services, '1c')
    @supplier_count = (@suppliers_lot1a.map { |s| s['name'] } << @suppliers_lot1b.map { |s| s['name'] } << @suppliers_lot1c.map { |s| s['name'] }).flatten.uniq.count

    set_current_choices
  end
  # rubocop:enable Metrics/AbcSize

  private

  def set_current_choices
    TransientSessionInfo[session.id] = nil
    TransientSessionInfo[session.id, 'posted_locations'] = @posted_locations
    TransientSessionInfo[session.id, 'posted_services'] = @posted_services
    TransientSessionInfo[session.id, 'locations'] = @locations
    TransientSessionInfo[session.id, 'services'] = @services
  end

  protected

  def authorize_user
    authorize! :read, FacilitiesManagement
  end
end
