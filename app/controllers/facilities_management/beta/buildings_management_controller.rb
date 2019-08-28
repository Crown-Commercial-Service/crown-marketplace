require 'facilities_management/fm_buildings_data'
require 'facilities_management/fm_service_data'
require 'json'
module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management building_type save_new_building save_building_gia].freeze
    before_action :authorize_user, only: %i[buildings_management building_type save_new_building save_building_gia].freeze

    def buildings_management
      @error_msg = ''
      current_login_email = current_user.email.to_s

      @fm_building_data = FMBuildingData.new
      @building_count = @fm_building_data.get_count_of_buildings(current_login_email)
      @building_data = @fm_building_data.get_building_data(current_login_email)
    end

    def building_details_summary
      @error_msg = ''
      building_record = FacilitiesManagement::Buildings.find_by("user_id = '" + Base64.encode64(current_user.email.to_s) +
                                                                    "' and building_json->>'building-ref' = '#{params['id']}'")
      @building = building_record&.building_json
      @display_warning = building_record.blank? ? false : building_record&.status == 'Incomplete'
    end

    def building
      @back_link_href = 'buildings-management'
      @step = 1
      @next_step = "What's the internal area of the building?"
      @page_title = 'Create single building'
    end

    def building_gross_internal_area
      @back_link_href = %"../building-details-summary/#{params['id']}"
      @step = 2
      @page_title = 'Add building GIA'
      @next_step = 'Building type'

      fm_building_data = FMBuildingData.new
      building_details = fm_building_data.new_building_details(current_user.email.to_s) if params['id'].blank?
      building_details = fm_building_data.get_building_data_by_ref(current_user.email.to_s, params['id']) if params['id'].present?

      @building_name = building_details['building_json']['name'] if building_details['building_json'].present?
      @building_id = building_details['id']
      @building = building_details['building_json'] if building_details['building_json'].present?
      @building = building_details if building_details['name'].present?
      @editing = params['id'].present?
    end

    def save_building_gia
      id = params['building-id']
      gia = params[:gia]

      fm_building_data = FMBuildingData.new


      return_data = {}
      return_data[:gia] = gia
      return_data['building-id'] = id

      render json: {status: 200, result: retData}
    end

    def building_type
      @back_link_href = 'buildings-management'
      @step = 3
      @next_step = 'Select the level of security clearance needed'
      fm_building_data = FMBuildingData.new
      @building_details = fm_building_data.new_building_details(current_user.email.to_s) if params['id'].blank?
      @type_list = fm_building_data.building_type_list
      @type_list_titles = fm_building_data.building_type_list_titles
      @page_title = 'Add building GIA'

      @building_name = @building_details['building_json']['name']
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController building_type(): #{e}"
    end

    def building_address
      @error_msg = ''
    end

    def building_security_type
      @error_msg = ''
    end

    def save_new_building
      @new_building_json = request.raw_post
      @fm_building_data = FMBuildingData.new
      @fm_building_data.save_new_building(current_user.email.to_s, @new_building_json)
      j = { 'status': 200 }
      render json: j, status: 200
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsController save_buildings(): #{e}"
    end
  end
end
