require 'rails_helper'

RSpec.describe Geocoding do
  subject(:geocoding) { described_class.new }

  it 'returns longitude and latitude for postcode' do
    Geocoder::Lookup::Test.add_stub(
      'TS14 6RD', [{ 'coordinates' => [54.541098, -1.04577] }]
    )
    coordinates = geocoding.coordinates(postcode: 'TS14 6RD')
    expect(coordinates).to eq([54.541098, -1.04577])
  end
end
