class FacilitiesManagement::SelectLocationsController < ApplicationController
  require_permission :facilities_management, only: :select_location
  def select_location
    h = {}
    Nuts1Region.all.each { |x| h[x.code] = x.name }
    @regions = h
    h = {}
    FacilitiesManagement::Region.all.each { |x| h[x.code] = x.name }
    @subregions = h
  end
end
