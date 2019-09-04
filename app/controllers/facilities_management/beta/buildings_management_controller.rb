require 'facilities_management/fm_buildings_data'
require 'facilities_management/fm_service_data'
require 'json'
module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management building_details_summary building_type save_new_building save_building_address save_building_type save_building_gia save_security_type update_building_details update_building_gia update_building_type update_security_type].freeze
    before_action :authorize_user, only: %i[buildings_management building_details_summary building_type save_new_building save_building_address save_building_type save_building_gia save_security_type update_building_details update_building_gia update_building_type update_security_type].freeze

    # Entry Points
    def buildings_management
      @error_msg = ''
      current_login_email = current_user.email.to_s

      @fm_building_data = FMBuildingData.new
      @building_count = @fm_building_data.get_count_of_buildings(current_login_email)
      @building_data = @fm_building_data.get_building_data(current_login_email)
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController buildings_management(): #{e}"
    end

    def building_details_summary
      @error_msg = ''
      @building_id = building_id_from_inputs
      @base_path = request.method.to_s == 'GET' ? '../' : './'

      building_record = FacilitiesManagement::Buildings.find_by("user_id = '" + Base64.encode64(current_user.email.to_s) +
                                                                    "' and id = '#{@building_id}'")
      @building = building_record&.building_json
      @display_warning = building_record.blank? ? false : building_record&.status == 'Incomplete'
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController building_details_summary(): #{e}"
    end

    def building
      @back_link_href = 'buildings-management'
      @step = 1
      @next_step = "What's the internal area of the building?"
      @page_title = 'Create single building'

      @building_id = building_id_from_inputs
      if params['id'].present?
        building_record = FacilitiesManagement::Buildings.find_by("user_id = '" + Base64.encode64(current_user.email.to_s) +
                                                                    "' and id = '#{@building_id}'")
        @building = building_record&.building_json
        @page_title = 'Change building details'
        @editing = true
      else
        @building = {}
        @building['address'] = {}
        @editing = false
      end
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController building(): #{e}"
    end

    def building_gross_internal_area
      local_building_id = building_id_from_inputs
      @back_link_href = "./building-details-summary/#{local_building_id}"
      @step = 2
      @editing = params['id'].present?
      @page_title = if @editing
                      t('facilities_management.beta.building-gross-internal-area.edit_header')
                    else
                      t('facilities_management.beta.building-gross-internal-area.add_header')
                    end
      @next_step = 'Building type'
      @inline_error_summary_title = 'There is a problem'
      @inline_error_summary_body_href = '#'
      @inline_summary_error_text = ''

      building_details = get_new_or_specific_building_by_id local_building_id
      @building = JSON.parse(building_details['building']) if building_details['building'].present?
      @building_name = @building['name']
      @building_id = local_building_id
    end

    def building_security_type
      fm_building_data = FMBuildingData.new
      local_building_id = building_id_from_inputs
      building_details = get_new_or_specific_building_by_id local_building_id
      @building = JSON.parse(building_details['building'])
      @editing = params['id'].present?
      @back_link_href = if @editing
                          "./building-details-summary/#{local_building_id}"
                        else
                          './buildings-management/'
                        end

      @inline_error_summary_title = 'You must select level of security clearance'
      @inline_error_summary_body_href = '#'
      @inline_summary_error_text = 'Select the level of security clearance needed'
      @step = 4
      @next_step = 'Buildings details summary'
      @type_list = fm_building_data.building_type_list
      @type_list_titles = fm_building_data.building_type_list_titles
      @building_name = @building['name']
      @building_id = local_building_id
      @security_types = fm_building_data.security_types
      @page_title = 'Change Security Type' if @editing
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_buildings(): #{e}"
    end

    def building_type
      local_building_id = building_id_from_inputs
      fm_building_data = FMBuildingData.new
      building_details = get_new_or_specific_building_by_id local_building_id

      @inline_error_summary_title = 'You must select the type of building'
      @inline_error_summary_body_href = '#'
      @inline_summary_error_text = 'Choose the building type that best describes your building'
      @back_link_href = 'buildings-management'
      @step = 3
      @next_step = 'Select the level of security clearance needed'
      @editing = params['id'].present?
      @back_link_href = if @editing
                          "./building-details-summary/#{local_building_id}"
                        else
                          './buildings-management/'
                        end

      @type_list = fm_building_data.building_type_list
      @type_list_titles = fm_building_data.building_type_list_titles
      @building_id = building_details['id'].blank? ? nil : building_details['id']
      @building = JSON.parse(building_details['building'])
      @building_name = @building['name']
      @page_title = @editing ? 'Change building type' : 'Building type'
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController building_type(): #{e}"
    end

    def building_address
      @building_id = building_id_from_inputs
      fm_building_data = FMBuildingData.new
      building_details = fm_building_data.new_building_details(@building_id)
      building = JSON.parse(building_details['building_json'])
      @back_link_href = 'building'
      @step = 1.5
      @next_step = "What's the internal area of the building?"
      @page_title = 'Add missing address'
      @building_name = building['name']
      @skip_link_href = '#'
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController building_address(): #{e}"
    end

    # Entry points for data storage
    # New bulilding Save Methods
    def save_new_building
      new_building_json = request.raw_post
      fm_building_data = FMBuildingData.new
      building_id = fm_building_data.save_new_building current_user.email.to_s, new_building_json
      cache_new_building_id building_id
      add = JSON.parse(new_building_json)
      postcode = add['address']['fm-address-postcode']
      save_region(postcode)
      j = { 'status': 200, 'fm_building-id': building_id.to_s }
      render json: j, status: 200
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_new_building(): #{e}"
    end

    def save_building_gia
      key = 'gia'
      building_gia = request.raw_post
      save_building_property(key, building_gia.gsub('"', ''))
      j = { 'status': 200 }
      render json: j, status: 200
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_building_gia(): #{e}"
    end

    def save_building_type
      key = 'building-type'
      building_type = request.raw_post
      save_building_property(key, building_type)
      j = { 'status': 200 }
      render json: j, status: 200
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_building_type(): #{e}"
    end

    def save_building_address
      key = 'address'
      new_address = request.raw_post
      save_building_property(key, new_address)
      j = { 'status': 200 }
      render json: j, status: 200
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_building_address(): #{e}"
    end

    def save_security_type
      save_building_property('security-type', params['security-type'])
      save_building_property('security-details', params['security-details'])

      j = { 'status': 200 }
      render json: j, status: 200
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_security_type(): #{e}"
    end

    # Edit Building Update Methods
    # rubocop:disable Metrics/AbcSize
    def update_building_details
      validate_input_building

      raise "Building  #{params['building-id']} details - name not saved" unless update_and_validate_changes params['building-id'], 'name', params['building-name'].strip

      raise "Building #{params['building-id']} details - description not saved" unless update_and_validate_changes params['building-id'], 'description', params['building-description'].strip

      raise "Building #{params['building-id']} details - ref not saved" unless update_and_validate_changes params['building-id'], 'building-ref', params['building-ref'].strip

      raise "Building #{params['building-id']} details - address not saved" unless update_and_validate_changes params['building-id'], 'address', params['building-address']

      validate_and_update_building params['building_id'].to_s
      render json: { status: 200, result: (get_return_data params['building-id'])[:name] = params['building-name'] }
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController update_building_details(): #{e}"
      raise e
    end
    # rubocop:enable Metrics/AbcSize

    def update_building_gia
      status = 200
      validate_input_building

      raise "Building #{params['building-id']} GIA not saved" unless update_and_validate_changes params['building-id'], 'gia', params[:gia]

      validate_and_update_building params['building-id'].to_s
      render json: { status: status, result: (get_return_data params['building-id'])[:gia] = params[:gia] }
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController save_building_gia(): #{e}"
      raise e
    end

    def update_building_type
      status = 200
      validate_input_building

      raise "Building #{params['building-id']} type not saved" unless update_and_validate_changes params['building-id'], 'building-type', params['building-type']

      validate_and_update_building params['building_id'].to_s
      render json: { status: status, result: (get_return_data params['building-id'])['building-type'] = params['building-type'] }
    end

    def update_security_type
      status = 200
      validate_input_building
      raise "Security #{params['building-id']} type not saved" unless update_and_validate_changes params['building-id'], 'security-type', params['security-type']

      raise "Security #{params['building-id']} details not saved" unless update_and_validate_changes params['building-id'], 'security-details', params['security-details']

      render json: { status: status, result: (get_return_data params['building-id'])['security-type'] = params['security-type'] }
    end

    # Helpers
    def stringify_address(building_ref, address_json_string)
      if address_json_string.present?
        address = address_json_string
        "#{address['fm-address-line-1'].strip},#{address['fm-address-line-2'].strip}," \
          "#{address['fm-address-town'].strip},#{address['fm-address-county'].strip},#{address['fm-address-postcode'].strip}," \
          "#{building_ref.strip}"
      else
        ''
      end
    end
    helper_method :stringify_address

    def building_id_from_inputs
      return params['id'] if params['id'].present?

      return cookies['fm-building-id'] if cookies.key?('fm-building-id')

      nil
    end

    # Data retrieval helpers - to be moved to the service layer?
    def get_new_or_specific_building_by_id(building_id)
      fm_building_data = FMBuildingData.new
      building_details = fm_building_data.new_building_details(current_user.email.to_s) if building_id.blank?
      building_details = fm_building_data.get_building_data_by_id(current_user.email.to_s, building_id).first if building_id.present?
      building_details
    end

    def get_return_data(building_id)
      # builds hash to be used as the edit-building return value
      { 'building-id' => building_id }
    end

    # Data changing methods
    def save_region(postcode)
      key = 'region'
      region = region(postcode)
      save_building_property(key, region.to_s)
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_region(): #{e}"
    end

    def update_and_validate_changes(building_id, property_name, new_value)
      fm_building_data = FMBuildingData.new

      if property_name == 'address'
        fm_building_data.save_building_property_activerecord building_id, property_name, new_value.keys.zip(new_value.values).to_h.except('building-ref')
        true
      else
        fm_building_data.save_building_property_activerecord building_id, property_name, new_value
        updated_building = JSON.parse(get_new_or_specific_building_by_id(building_id)['building'])
        (updated_building.key?(property_name) ? updated_building[property_name].to_s == new_value.to_s : false)
      end
    end

    def save_building_property(key, value)
      building_id = cookies['fm_building_id']
      fm_building_data = FMBuildingData.new
      fm_building_data.save_building_property(building_id, key, value.gsub('"', ''))
      validate_and_update_building building_id
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_building_property(): #{e}"
    end

    def save_building_property_using_ar(key, value)
      building_id = cookies['fm_building_id']
      fm_building_data = FMBuildingData.new
      fm_building_data.save_building_property_activerecord(building_id, key, value)
      validate_and_update_building building_id
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_building_property(): #{e}"
    end

    def validate_and_update_building(building_id)
      db = FMBuildingData.new
      building = db.get_building_data_by_id current_user.email.to_s, building_id
      new_status = get_building_ready_status(JSON.parse(building[0]['building'])) if building[0].present?
      db.update_building_status(building_id, new_status, current_user.email.to_s) if building[0].present? && new_status != building[0]['status']
    end

    def get_building_ready_status(building)
      !(building['name'].empty? || building['region'].empty? ||
          building['building-type'].empty? || building['security-type'].empty? ||
          building['gia'].empty?)
    end

    def validate_input_building
      # used to verify building-id parameter
      raise "Building #{params['building-id']} not found" if get_new_or_specific_building_by_id(params['building-id'].to_s).blank?

      true
    end

    def cache_new_building_id(building_id)
      secure_cookie = Rails.env.development? ? false : true
      cookies['fm_building_id'] = { value: building_id.to_s, secure: secure_cookie }
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController building_security_type(): #{e}"
    end

    def region(postcode)
      fm_building_data = FMBuildingData.new
      region_json = JSON.parse(fm_building_data.region_info_for_post_town(postcode))
      region_json['result']['region']
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController region(): #{e}"
    end
  end
end
