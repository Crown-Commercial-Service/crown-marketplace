Geocoder.configure(
  lookup: :google,
  api_key: ENV.fetch('GOOGLE_GEOCODING_API_KEY'),
  units: :mi,
  distance: :spherical
)
