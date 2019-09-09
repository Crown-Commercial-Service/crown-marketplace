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
      update_building_data if params['detail-type'].present? && request.method == 'POST'

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
      @building = JSON.parse(building_details['building_json']) if building_details['building_json'].present?
      @building_name = @building['name']
      @building_id = local_building_id
    end

    # rubocop:disable Metrics/AbcSize
    def building_security_type
      fm_building_data = FMBuildingData.new
      local_building_id = building_id_from_inputs
      building_details = get_new_or_specific_building_by_id local_building_id
      @building = JSON.parse(building_details['building_json'])
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
      @building_name = @building['name']
      @building_sec_type = @building['security-type']
      @other_is_used = false
      @other_value = 'other'
      @building_id = local_building_id
      @security_types = fm_building_data.security_types
      @page_title = 'Change Security Type' if @editing

      if @security_types.select { |x| x['title'] == @building_sec_type }.empty? && @building_sec_type != ''
        @other_is_used = true
        @other_value = @building_sec_type
      end
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_buildings(): #{e}"
    end
    # rubocop:enable Metrics/AbcSize

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
      @building = JSON.parse(building_details['building_json'])
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
    # rubocop:disable Metrics/CyclomaticComplexity
    def update_building_data
      if (details_type = params['detail-type']).present?
        case details_type
        when 'fm-building-type'
          update_building_type
        when 'fm-building-security-type'
          update_security_type
        when 'fm-building-details'
          update_building_details
        when 'fm-bm-internal-square-area'
          update_building_gia
        else
          true
        end
      end
    rescue StandardError => e
      @inline_error_summary_title = 'Problem saving data'
      @inline_summary_error_text = e
    end

    # rubocop:enable Metrics/CyclomaticComplexity

    def update_building_details
      validate_input_building
      building_id = building_id_from_inputs

      raise "Building  #{building_id} details - name not saved" unless update_and_validate_changes building_id, 'name', params['fm-building-name']

      raise "Building #{building_id} details - description not saved" unless update_and_validate_changes building_id, 'description', params['fm-building-desc']

      raise "Building #{building_id} details - ref not saved" unless update_and_validate_changes building_id, 'building-ref', params['building-ref']

      raise "Building #{building_id} details - address not saved" unless update_and_validate_changes building_id, 'address', params['address-json']

      validate_and_update_building building_id
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController update_building_details(): #{e}"
      raise e
    end

    def update_building_gia
      validate_input_building
      building_id = building_id_from_inputs

      raise "Building #{building_id} GIA not saved" unless update_and_validate_changes building_id, 'gia', params['fm-bm-internal-square-area']

      validate_and_update_building building_id.to_s
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController save_building_gia(): #{e}"
      raise e
    end

    def update_building_type
      validate_input_building
      building_id = building_id_from_inputs
      raise "Building #{building - id} type not saved" unless update_and_validate_changes building_id, 'building-type', params['fm-building-type-radio']

      validate_and_update_building building_id_from_inputs
    end

    def update_security_type
      validate_input_building
      building_id = building_id_from_inputs

      raise "Security #{building_id} type not saved" unless update_and_validate_changes building_id, 'security-type', params['fm-building-security-type-radio']
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
      return params['building-id'] if params['building-id'].present?
      return cookies['fm_building_id'] if cookies.key?('fm_building_id')

      nil
    end

    # Data retrieval helpers - to be moved to the service layer?
    def get_new_or_specific_building_by_id(building_id)
      fm_building_data = FMBuildingData.new
      building_details = fm_building_data.new_building_details(building_id)
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
        new_addr = JSON.parse(new_value)
        fm_building_data.save_building_property_activerecord building_id, property_name, new_addr.keys.zip(new_addr.values).to_h.except('building-ref')
        true
      else
        fm_building_data.save_building_property_activerecord building_id, property_name, new_value
        updated_building = JSON.parse(get_new_or_specific_building_by_id(building_id)['building_json'])
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

    def validate_and_update_building(building_id)
      db = FMBuildingData.new
      building = db.get_building_data_by_id current_user.email.to_s, building_id if building_id.present?
      new_status = get_building_ready_status(JSON.parse(building[0]['building'])) if building.present?
      db.update_building_status(building_id, new_status, current_user.email.to_s) if building.present?
    end

    def building_element_valid?(building, key_name)
      (building[key_name].present? ? !building[key_name].empty? : false)
    end

    def get_building_ready_status(building)
      building_element_valid?(building, 'name') || building_element_valid?(building, 'region') ||
        building_element_valid?(building, 'building-type') || building_element_valid?(building, 'security-type') ||
        building_element_valid?(building, 'gia')
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
