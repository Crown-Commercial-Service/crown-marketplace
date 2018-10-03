class Geocoding
  DEFAULT_PARAMS = { params: { region: 'uk' } }.freeze

  def coordinates(postcode:)
    Geocoder.coordinates(postcode, DEFAULT_PARAMS)
  end
end
