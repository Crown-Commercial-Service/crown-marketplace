class FacilitiesManagement::BuildingsController < ApplicationController
  require_permission :facilities_management, only: %i[buildings new_building].freeze

  def buildings
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Error'
  end

  def new_building
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end
end
