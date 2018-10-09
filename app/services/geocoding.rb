class Geocoding
  DEFAULT_PARAMS = { params: { region: 'uk' } }.freeze

  attr_reader :point_factory

  def initialize
    @point_factory = RGeo::Geographic.spherical_factory(srid: 4326)
  end

  def point(postcode:)
    lat, lng = Geocoder.coordinates(postcode, DEFAULT_PARAMS)
    return nil unless lat

    point_factory.point(lng, lat)
  end
end
