require 'json'
require 'facilities_management/fm_service_data'
class FacilitiesManagement::SelectServicesController < ApplicationController
  require_permission :facilities_management, only: %i[select_services save_lift_data].freeze

  def select_services
    # Inline error text for this page
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'You must select at least one service before clicking the save continue button'
    fm_service_data = FMServiceData.new
    @services = fm_service_data.services
    @work_packages = fm_service_data.work_packages
  rescue StandardError => e
    Rails.logger.warn "Error: SelectServicesController select_services(): #{e}"
  end

  def save_lift_data
    raw_post = request.raw_post
    lift_data_json = JSON.parse(raw_post)
    building_id = lift_data_json['building_id']
    fm_service_data = FMServiceData.new
    fm_service_data.save_lift_data(current_login.email.to_s, building_id, lift_data_json)

    count = fm_service_data.unset_service_count(current_login.email.to_s, building_id)

    url = count.positive? ? '/facilities-management/buildings/units-of-measurement?building_id=' + building_id : '/facilities-management/buildings-list'

    j = { 'status': 200, 'next': url }

    render json: j, status: 200
  rescue StandardError => e
    Rails.logger.warn "Error: SelectServicesController save_lift_data(): #{e}"
  end
end
