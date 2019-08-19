module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management].freeze
    before_action :authorize_user, only: %i[buildings_management].freeze

    def index
      @error_msg = ''
      current_login_email = current_user.email.to_s
      @fm_building_data = FMBuildingData.new
      @building_count = @fm_building_data.get_count_of_buildings(current_login_email)
      @building_data = @fm_building_data.get_building_data(current_login_email)
    end

    def details
      @error_msg = ''
      current_login_email = current_user.email.to_s
      @fm_building_data = FMBuildingData.new
      @building_id = @params['id']
      @building_data = @fm_building_data.get_building_data(current_login_email)
    end

    def buildings_management
      @error_msg = ''
      current_login_email = current_user.email.to_s

      @fm_building_data = FMBuildingData.new
      @building_count = @fm_building_data.get_count_of_buildings(current_login_email)
      @building_data = @fm_building_data.get_building_data(current_login_email)
    end

    def building
      @error_msg = ''
    end

    def building_type
      @error_msg = ''
    end

    def building_gross_internal_area
      @error_msg = ''
    end

    def building_details_summary
      @error_msg = ''
    end

    def building_address
      @error_msg = ''
    end

    def building_security_type
      @error_msg = ''
    end
  end
end
