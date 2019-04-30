class FacilitiesManagement::SelectLocationsController < ApplicationController
  require_permission :facilities_management, only: :select_location

  def select_location
    # Inline error text for this page
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'You must select at least one location before clicking the save continue button'
    # Get nuts regions
    h = {}
    Nuts1Region.all.each { |x| h[x.code] = x.name }
    @regions = h
    h = {}
    FacilitiesManagement::Region.all.each { |x| h[x.code] = x.name }
    @subregions = h
  end

end
