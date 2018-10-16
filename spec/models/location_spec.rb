require 'rails_helper'

RSpec.describe Location do
  subject(:location) { described_class.new('W1A 1AA') }

  before do
    Geocoder::Lookup::Test.add_stub(
      'W1A 1AA', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )
  end

  it 'has a postcode' do
    expect(location).to respond_to(:postcode)
  end

  it 'has a point' do
    expect(location).to respond_to(:point)
  end

  it 'sets point to nil when the postcode is invalid' do
    invalid_location = described_class.new('invalid-postcode')
    expect(invalid_location.point).to be_nil
  end
end
