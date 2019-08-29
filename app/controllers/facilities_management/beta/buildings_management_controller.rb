require 'facilities_management/fm_buildings_data'
require 'facilities_management/fm_service_data'
require 'json'
module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management building_type save_new_building save_building_address save_building_type save_building_gia].freeze
    before_action :authorize_user, only: %i[buildings_management building_type save_new_building save_building_address save_building_type save_building_gia].freeze

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
      building_record = FacilitiesManagement::Buildings.find_by("user_id = '" + Base64.encode64(current_user.email.to_s) +
                                                                    "' and building_json->>'building-ref' = '#{params['id']}'")
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
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController building(): #{e}"
    end

    def get_new_or_specific_building_by_ref(building_ref)
      fm_building_data = FMBuildingData.new
      building_details = fm_building_data.new_building_details(current_user.email.to_s) if building_ref.blank?
      building_details = fm_building_data.get_building_data_by_ref(current_user.email.to_s, building_ref) if building_ref.present?
      building_details
    end

    def building_gross_internal_area
      @back_link_href = "../building-details-summary/#{params['id']}"
      @step = 2
      @editing = params['id'].present?
      @page_title = if @editing
                      t('facilities_management.beta.building-gross-internal-area.edit_header')
                    else t('facilities_management.beta.building-gross-internal-area.add_header')
                    end
      @next_step = 'Building type'

      building_details = get_new_or_specific_building_by_ref params['id']
      @building_name = building_details['building_json']['name']
      @building_id = building_details['id']
      @building = building_details['building_json'] if building_details['building_json'].present?
    end

    def get_existing_building(building_id)
      fm_building_data = FMBuildingData.new
      (fm_building_data.get_building_data_by_id current_user.email.to_s, building_id).first
    end

    def get_return_data(building_id)
      { 'building-id' => building_id }
    end

    def gia_update_is_valid(building_id, input_gia)
      fm_building_data = FMBuildingData.new
      fm_building_data.save_building_property building_id, 'gia', input_gia
      JSON.parse(get_existing_building(building_id)['building'])['gia'].to_s == input_gia
    end

    def save_building_gia
      status = 200
      raise "Building #{id} not found" if get_existing_building(params['building-id']).blank?

      raise "Building #{id} GIA not saved" unless gia_update_is_valid params['building-id'], params[:gia]

      render json: { status: status, result: (get_return_data params['building-id'])[:gia] = params[:gia] }
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController save_building_gia(): #{e}"
      raise e
    end

    def building_type
      @inline_error_summary_title = 'You must select type of building'
      @inline_error_summary_body_href = '#'
      @inline_summary_error_text = 'Choose the building type that best describes your building'
      building_id = cookies['fm_building_id']
      @back_link_href = 'buildings-management'
      @step = 3
      @next_step = 'Select the level of security clearance needed'
      fm_building_data = FMBuildingData.new
      @building_details = fm_building_data.new_building_details(current_user.email.to_s) if params['id'].blank?
      @type_list = fm_building_data.building_type_list
      @type_list_titles = fm_building_data.building_type_list_titles
      building_details = fm_building_data.new_building_details(building_id)
      building = JSON.parse(building_details['building_json'])
      @building_name = building['name']
      @page_title = 'Building type'
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController building_type(): #{e}"
    end

    def building_address
      @building_id = cookies['fm_building_id']
      fm_building_data = FMBuildingData.new
      building_details = fm_building_data.new_building_details(@building_id)
      building = JSON.parse(building_details['building_json'])
      @back_link_href = 'building'
      @step = 1.5
      @next_step = "What's the internal area of the building?"
      @page_title = 'Add missing address'
      @building_name = building['name']
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController building_address(): #{e}"
    end

    def save_building_property(key, value)
      building_id = cookies['fm_building_id']
      fm_building_data = FMBuildingData.new
      fm_building_data.save_building_property(building_id, key, value)
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_building_property(): #{e}"
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

    def building_security_type
      @error_msg = ''
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_buildings(): #{e}"
    end

    def cache_new_building_id(building_id)
      secure_cookie = Rails.env.development? ? false : true
      cookies['fm_building_id'] = { value: building_id.to_s, secure: secure_cookie }
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController building_security_type(): #{e}"
    end

    def save_new_building
      new_building_json = request.raw_post
      fm_building_data = FMBuildingData.new
      building_id = fm_building_data.save_new_building current_user.email.to_s, new_building_json
      cache_new_building_id building_id
      j = { 'status': 200, 'fm_building-id': building_id.to_s }
      render json: j, status: 200
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_new_building(): #{e}"
    end
  end
end
