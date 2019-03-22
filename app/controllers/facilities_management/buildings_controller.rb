class FacilitiesManagement::BuildingsController < ApplicationController
  require_permission :facilities_management, only: [:buildings, :new_building]

  def buildings
  end

  def new_building
  end
end
