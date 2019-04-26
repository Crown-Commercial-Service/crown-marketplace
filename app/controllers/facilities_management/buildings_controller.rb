require 'facilities_management/fm_buildings_data'
require 'facilities_management/fm_service_data'
require 'json'
class FacilitiesManagement::BuildingsController < ApplicationController
  require_permission :facilities_management, only: %i[save_uom_value buildings new_building manual_address_entry_form save_building building_type update_building select_services_per_building units_of_measurement].freeze

  def select_services_per_building
    @inline_error_summary_title = 'Services are not selected'
    @inline_error_summary_body_href = '#fm-service-count'
    @inline_summary_error_text = 'You must select at least one service before continuing'
  end

  def buildings
    @uom_values = []
    current_login_email = current_login.email.to_s
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Error'
    @fm_building_data = FMBuildingData.new
    @building_count = @fm_building_data.get_count_of_buildings(current_login_email)
    @building_data = @fm_building_data.get_building_data(current_login_email)
    fm_service_data = FMServiceData.new
    uom_values = fm_service_data.uom_values(current_login_email)
    uom_values.each do |values|
      values['description'] = fm_service_data.work_package_description(values['service_code'])
      values['unit_text'] = fm_service_data.work_package_unit_text(values['service_code'])
      @uom_values.push(values)
    end
    @lift_data = fm_service_data.get_lift_data(current_login_email)
    @uom_values
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController buildings(): #{e}"
  end

  def new_building
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def manual_address_entry_form
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def save_building
    @new_building_json = request.raw_post
    @fm_building_data = FMBuildingData.new
    @fm_building_data.save_building(current_login.email.to_s, @new_building_json)
    j = { 'status': 200 }
    render json: j, status: 200
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController save_buildings(): #{e}"
  end

  def update_building
    @new_building_json = request.raw_post
    obj = JSON.parse(@new_building_json)
    id = obj['id']
    @fm_building_data = FMBuildingData.new
    @fm_building_data.update_building(current_login.email.to_s, id, @new_building_json)
    j = { 'status': 200 }
    render json: j, status: 200
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController update_building(): #{e}"
  end

  def units_of_measurement
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Enter a value'

    building_id = params['building_id']
    fm_service_data = FMServiceData.new
    service_data = fm_service_data.unit_of_measurement_unset(current_login.email.to_s, building_id)
    @building_id = building_id

    if service_data['hasService'] == true
      @service_code = service_data['service_code']
      @is_lift = @service_code.to_s == 'C.5'
      @service_title = service_data['service_description']
      @uom_title = service_data['title_text']
      @uom_example = service_data['example_text']
      @unit_text = service_data['unit_text']
    else
      redirect_to('/facilities-management/buildings-list')
    end
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController units_of_measurement(): #{e}"
  end

  def save_uom_value
    uom = request.raw_post
    uom_json = JSON.parse(uom)
    building_id = uom_json['building_id']
    service_code = uom_json['service_code']
    uom_value = uom_json['uom_value']

    fm_service_data = FMServiceData.new
    fm_service_data.add_uom_value(current_login.email.to_s, building_id, service_code, uom_value)

    count = fm_service_data.unset_service_count(current_login.email.to_s, building_id)

    url = count.positive? ? '/facilities-management/buildings/units-of-measurement?building_id=' + building_id : '/facilities-management/buildings-list'

    j = { 'status': 200, 'next': url }

    render json: j, status: 200
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController save_uom_value(): #{e}"
  end

  def building_type
    fm_building_data = FMBuildingData.new
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Please select an option before continuing'
    @type_list = fm_building_data.building_type_list
    @type_list_descriptions = fm_building_data.building_type_list_descriptions
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController building_type(): #{e}"
  end
end
