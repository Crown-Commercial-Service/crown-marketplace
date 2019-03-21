class FacilitiesManagement::BuildingsController < ApplicationController
  require_permission :facilities_management, only: :buildings

  def buildings
  end
end
