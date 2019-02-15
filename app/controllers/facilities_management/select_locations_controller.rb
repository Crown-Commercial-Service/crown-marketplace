
class FacilitiesManagement::SelectLocationsController < ApplicationController
  require_permission :none, only: :select_location
  def select_location
  end
end
