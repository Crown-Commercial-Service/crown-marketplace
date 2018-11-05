module Geolocatable
  def location
    @location ||= Location.new(postcode)
  end
end
