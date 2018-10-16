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

  it 'is valid when the postcode is valid' do
    expect(location.valid?).to be true
  end

  context 'with an invalid postcode' do
    let(:location) { described_class.new('invalid-postcode') }

    it 'sets point to nil' do
      expect(location.point).to be_nil
    end

    it 'is invalid' do
      expect(location.valid?).to be false
    end

    it 'sets an appropriate error message' do
      location.valid?
      expect(location.error).to eq 'Postcode is invalid'
    end
  end
end
