module FacilitiesManagement
  class Beta::BuildingsManagementController < FacilitiesManagement::BuildingsController
    before_action :authenticate_user!, only: %i[buildings_management].freeze
    before_action :authorize_user, only: %i[buildings_management].freeze

    def buildings_management
      @error_msg = ''
      current_login_email = current_user.email.to_s

      @fm_building_data = FMBuildingData.new
      @building_count = @fm_building_data.get_count_of_buildings(current_login_email)
      @building_data = @fm_building_data.get_building_data(current_login_email)
    end

    def building_details_summary
      @error_msg = ''
      current_login_email = current_user.email.to_s
      @fm_building_data = FMBuildingData.new
      building_count = @fm_building_data.get_count_of_buildings_by_id(current_login_email, params['id'])
      @building_data = if building_count.positive?
                         @fm_building_data.get_building_data_by_id(current_login_email, params['id'])
                       else
                         @building_data = nil
                       end

      @display_warning = true
      @display_warning = (@building_data[0][:status] if building_count.positive?)
      @building = (JSON.parse(@building_data[0]['building']) if building_count.positive?)

      @current_caption = @current_link_target = @current_name = @current_change_link = ''
      @thebuildingdata = @building.to_s
    end

    def row_valid?(property_name, caption, link_new_text, link_change_text, link_target)
      @current_caption = self.class.helpers.t(%Q|facilities_management.beta.building-details-summary.%{caption}|)
      current_new_link_text = self.class.helpers.t(%Q|facilities_management.beta.building-details-summary.%{link_new_text}|)
      current_change_link_text = self.class.helpers.t(%Q|facilities_management.beta.building-details-summary.%{link_change_text}|)
      @current_link_target = link_target
      @current_name = @building[property_name] if @building[property_name].present?
      @current_name = self.class.helpers.link_to current_new_link_text, link_target, class: 'govuk-link' if @building[property_name].blank?
      @current_change_link = ''
      @current_change_link = self.class.helpers.link_to current_change_link_text, link_target, class: 'govuk-link' if @building[property_name].present?
      @building[property_name].present?
    end
    helper_method :row_valid?

    def building
      @error_msg = ''
    end

    def building_type
      @error_msg = ''
    end

    def building_gross_internal_area
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
