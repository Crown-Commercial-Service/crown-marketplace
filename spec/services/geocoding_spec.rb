require 'rails_helper'

RSpec.describe Geocoding do
  subject(:geocoding) { described_class.new }

  describe 'point' do
    subject(:point) { geocoding.point(postcode: postcode) }

    context 'when the postcode is found' do
      let(:postcode) { 'TS14 6RD' }
      let(:longitude) { -1.04577 }
      let(:latitude) { 54.541098 }

      before do
        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => [latitude, longitude] }]
        )
      end

      it { is_expected.to have_attributes(longitude: longitude, latitude: latitude) }
    end

    context 'when the postcode is not found' do
      let(:postcode) { 'SE99 1AA' }

      before do
        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => nil }]
        )
      end

      it { is_expected.to be_nil }
    end
  end
end
