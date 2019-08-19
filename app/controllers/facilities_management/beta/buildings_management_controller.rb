module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management].freeze
    before_action :authorize_user, only: %i[buildings_management].freeze

    def buildings_management
      @error_msg = ''
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
