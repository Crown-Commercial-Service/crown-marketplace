require 'facilities_management/fm_buildings_data'
require 'facilities_management/fm_service_data'
require 'json'
class FacilitiesManagement::BuildingsController < FacilitiesManagement::FrameworkController
  before_action :authenticate_user!, only: %i[delete_building reset_buildings_tables region_info save_uom_value buildings new_building manual_address_entry_form save_building building_type update_building select_services_per_building units_of_measurement].freeze
  before_action :authorize_user, only: %i[delete_building reset_buildings_tables region_info save_uom_value buildings new_building manual_address_entry_form save_building building_type update_building select_services_per_building units_of_measurement].freeze

  def reset_buildings_tables
    fmd = FMBuildingData.new
    fmd.reset_buildings_tables
    j = { 'status': 200 }
    render json: j, status: 200
  end

  def select_services_per_building
    @inline_error_summary_title = 'Services are not selected'
    @inline_error_summary_body_href = '#fm-service-count'
    @inline_summary_error_text = 'You must select at least one service before continuing'
  end

  def buildings
    set_current_choices

    @uom_values = []
    current_login_email = current_user.email.to_s
    set_error_messages
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
    @message = e.to_s
    render 'error'
  end

  def new_building
    set_current_choices

    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def manual_address_entry_form
    set_current_choices

    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def save_building
    @new_building_json = request.raw_post
    @fm_building_data = FMBuildingData.new
    @fm_building_data.save_building(current_user.email.to_s, @new_building_json)
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
    @fm_building_data.update_building(current_user.email.to_s, id, @new_building_json)
    j = { 'status': 200 }
    render json: j, status: 200
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController update_building(): #{e}"
  end

  def region_info
    post_code = params['post_code']
    fm_building_data = FMBuildingData.new
    result = fm_building_data.region_info_for_post_town(post_code)
    render json: result
  rescue StandardError
    render json: { status: 404, error: 'Region not found' }
  end

  def units_of_measurement
    set_current_choices

    uom_error_messages

    building_id = params['building_id']
    fm_service_data = FMServiceData.new
    service_data = fm_service_data.unit_of_measurement_unset(current_user.email.to_s, building_id)
    @building_id = building_id

    if service_data['hasService'] == true
      @service_code = service_data['service_code']
      @is_lift = @service_code.to_s == 'C.5'

      if @is_lift
        @inline_error_summary_title = 'Invalid lift information'
        @inline_error_summary_body_href = '#'
        @inline_summary_error_text = 'Please enter a valid number'
      end

      @service_title = service_data['service_description']
      @uom_title = service_data['title_text']
      @uom_example = service_data['example_text']
      @unit_text = service_data['unit_text']
    else
      redirect_to_building_list
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
    fm_service_data.add_uom_value(current_user.email.to_s, building_id, service_code, uom_value)
    count = fm_service_data.unset_service_count(current_user.email.to_s, building_id)
    url = count.positive? ? '/facilities-management/buildings/units-of-measurement?building_id=' + building_id : '/facilities-management/buildings-list'
    j = { 'status': 200, 'next': url }
    render json: j, status: 200
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController save_uom_value(): #{e}"
  end

  def building_type
    set_current_choices

    fm_building_data = FMBuildingData.new
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Please select an option before continuing'
    @type_list = fm_building_data.building_type_list
    @type_list_descriptions = fm_building_data.building_type_list_descriptions
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController building_type(): #{e}"
  end

  def delete_building
    raw_post = request.raw_post
    raw_post_json = JSON.parse(raw_post)
    building_id = raw_post_json['building_id']
    fm_building_data = FMBuildingData.new
    fm_building_data.delete_building(current_user.email.to_s, building_id)
    j = { 'status': 200 }
    render json: j, status: 200
  rescue StandardError => e
    Rails.logger.warn "Error: BuildingsController delete_building: #{e}"
  end

  private

  def redirect_to_building_list
    # request.query_parameters['current_choices'] = params['current_choices'] if params['current_choices']
    # p = params.permit('current_choices', 'building_id', 'authenticity_token', 'utf8').merge(building_id: request.query_parameters['building_id'])
    # p = request.query_parameters.merge({:current_choices => params['current_choices']})
    redirect_to('/facilities-management/buildings-list', current_choices: params['current_choices'], 'fm-locations': params['fm-locations'], 'fm-services': params['fm-services'], flash: { 'current_choices': params['current_choices'], 'fm-locations': params['fm-locations'], 'fm-services': params['fm-services'] })
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  # use
  #       <%= hidden_field_tag 'current_choices', TransientSessionInfo[session.id].to_json  %>
  # to copy the cached choices
  def set_current_choices
    super

    TransientSessionInfo[session.id, 'fm-services'] = JSON.parse(flash['fm-services']) if flash['fm-services'] && params['fm-services'].nil?
    TransientSessionInfo[session.id, 'fm-locations'] = JSON.parse(flash['fm-locations']) if flash['fm-services'] && params['fm-services'].nil?

    TransientSessionInfo[session.id, 'fm-contract-length'] = params['fm-contract-length'] if params['fm-contract-length']
    TransientSessionInfo[session.id, 'fm-extension'] = params['fm-extension'] if params['fm-extension']
    TransientSessionInfo[session.id, 'contract-extension-radio'] = params['contract-extension-radio'] if params['contract-extension-radio']

    TransientSessionInfo[session.id, 'fm-contract-cost'] =
      if params['contract-cost-radio'] == 'no'
        0.0
      else
        params['fm-contract-cost'] # if params['fm-contract-cost']
      end

    TransientSessionInfo[session.id, 'contract-tupe-radio'] = params['contract-tupe-radio'] if params['contract-tupe-radio']
    TransientSessionInfo[session.id, 'contract-extension-radio'] = params['contract-extension-radio'] if params['contract-extension-radio']
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize

  def set_error_messages
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Error'
  end

  def uom_error_messages
    @inline_error_summary_title = 'The value entered is invalid'
    @inline_error_summary_body_href = '#fm-uom-input'
    @inline_summary_error_text = 'Enter a number in the correct format'
  end
end
