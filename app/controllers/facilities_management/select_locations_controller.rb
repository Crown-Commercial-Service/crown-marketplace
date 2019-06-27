class FacilitiesManagement::SelectLocationsController < ApplicationController
  before_action :authenticate_user!, only: :select_location
  before_action :authorize_user, only: :select_location

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

  protected

  def authorize_user
    authorize! :read, FacilitiesManagement
  end
end
