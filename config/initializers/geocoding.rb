Geocoder.configure(
  lookup: :google,
  api_key: Marketplace.google_geocoding_api_key,
  units: :mi,
  distance: :spherical,
  always_raise: :all,
  cache: {}
)
