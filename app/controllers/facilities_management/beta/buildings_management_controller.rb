require 'facilities_management/fm_buildings_data'
require 'facilities_management/fm_service_data'
require 'json'
module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management building_type].freeze
    before_action :authorize_user, only: %i[buildings_management building_type].freeze

    def buildings_management
      @error_msg = ''
    end

    def building
      @back_link = '/facilities-management/beta/'
      @step = 1
      @next_step = "What's the internal area of the building?"
      @page_title = 'Create single building'
    end

    def building_type
      @back_link = '/facilities-management/beta/'
      @step = 3
      @next_step = 'Select the level of security clearance needed'
      fm_building_data = FMBuildingData.new
      @type_list = fm_building_data.building_type_list
      @type_list_titles = fm_building_data.building_type_list_titles
      @building_name = 'Phoenix house'
    rescue StandardError => e
      Rails.logger.warn "Error: BuildingsManagementController building_type(): #{e}"
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
