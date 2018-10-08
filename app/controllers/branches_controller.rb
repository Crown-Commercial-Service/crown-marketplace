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

    lat_lng = Geocoding.new.coordinates(postcode: @postcode.to_s)

    unless lat_lng
      flash[:error] = "Couldn't find that postcode"
      redirect_to search_path
      return
    end

    point_factory = RGeo::Geographic.spherical_factory(srid: 4326)
    point = point_factory.point(*lat_lng)
    @branches = Branch.near(point, within_metres: 1609.34 * Branch::DEFAULT_SEARCH_RANGE_IN_MILES)
  end
end
