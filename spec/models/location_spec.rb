require 'rails_helper'

RSpec.describe Location do
  subject(:location) { described_class.new('W1A 1AA') }

  context 'when the postcode is found' do
    before do
      Geocoder::Lookup::Test.add_stub(
        'W1A 1AA', [{ 'coordinates' => [51.5149666, -0.119098] }]
      )
    end

    it { is_expected.to be_found }

    it { is_expected.to respond_to(:postcode) }

    it { is_expected.to respond_to(:point) }
  end

  context 'with a valid postcode that could not be found' do
    before do
      Geocoder::Lookup::Test.add_stub(
        'W1A 1AA', [{ 'coordinates' => [] }]
      )
    end

    it { is_expected.not_to be_found }
  end

  context 'with an invalid postcode' do
    subject(:location) { described_class.new('invalid-postcode') }

    it { is_expected.to have_attributes(point: nil) }

    it { is_expected.not_to be_found }
  end
end
