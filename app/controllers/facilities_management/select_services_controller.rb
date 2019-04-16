require 'json'
require 'facilities_management/fm_service_data'
class FacilitiesManagement::SelectServicesController < ApplicationController
  require_permission :facilities_management, only: %i[select_services].freeze

  def select_services
    # Inline error text for this page
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'You must select at least one service before clicking the save continue button'
    fm_service_data = FMServiceData.new
    @services = fm_service_data.services
    @work_packages = fm_service_data.work_packages
  end
end
