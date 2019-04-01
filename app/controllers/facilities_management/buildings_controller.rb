require 'facilities_management/fm_buildings_data'
require 'json'
class FacilitiesManagement::BuildingsController < ApplicationController
  require_permission :facilities_management, only: %i[buildings new_building manual_address_entry_form save_building].freeze

  def buildings
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Error'
    @fm_building_data = FMBuildingData.new
    @building_count = @fm_building_data.get_count_of_buildings(current_login.email.to_s)
    @building_data = @fm_building_data.get_building_data(current_login.email.to_s)
  end

  def new_building
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def manual_address_entry_form
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def save_building
    @new_building_json = request.raw_post
    @fm_building_data = FMBuildingData.new
    @fm_building_data.create_facilities_management_buildings_table
    @fm_building_data.save_building(current_login.email.to_s, @new_building_json)
  end
end
