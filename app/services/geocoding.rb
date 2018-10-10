class Geocoding
  DEFAULT_PARAMS = { params: { region: 'uk' } }.freeze

  def self.point_factory
    @point_factory ||= RGeo::Geographic.spherical_factory(srid: 4326)
  end

  def point(postcode:)
    lat, lng = Geocoder.coordinates(postcode, DEFAULT_PARAMS)
    return nil unless lat

    self.class.point_factory.point(lng, lat)
  end
end
