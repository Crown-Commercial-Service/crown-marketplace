require 'facilities_management/fm_buildings_data'
require 'json'
module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management].freeze
    before_action :authorize_user, only: %i[buildings_management].freeze

    def index
      current_login_email = current_user.email.to_s.strip

      @fm_building_data = FMBuildingData.new
      @building_count = @fm_building_data.get_count_of_buildings(current_login_email)
      @building_data = @fm_building_data.get_building_data(current_login_email)
    end

    def details
      current_login_email = current_user.email.to_s

      @fm_building_data = FMBuildingData.new
      @building_id = @params['id']
      @building_data = @fm_building_data.get_building_data(current_login_email)
    end
  end
end
