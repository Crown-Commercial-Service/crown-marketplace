class BranchesController < ApplicationController
  def index
    if params[:postcode].nil?
      @branches = Branch.all
      return
    end

    @postcode = UKPostcode.parse(params[:postcode])

    unless @postcode.valid?
      flash[:error] = 'Postcode is invalid'
      redirect_to search_path
      return
    end

    @point = Geocoding.new.point(postcode: @postcode.to_s)

    unless @point
      flash[:error] = "Couldn't find that postcode"
      redirect_to search_path
      return
    end

    @branches = Branch.near(@point, within_metres: helpers.miles_to_metres(Branch::DEFAULT_SEARCH_RANGE_IN_MILES))
  end
end
