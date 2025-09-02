require 'rails_helper'

RSpec.describe Geocoding do
  subject(:geocoding) { described_class.new }

  describe '#point' do
    subject(:point) { geocoding.point(postcode:) }

    context 'when the postcode is found' do
      let(:postcode) { 'TS14 6RD' }
      let(:longitude) { -1.04577 }
      let(:latitude) { 54.541098 }

      before do
        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => [latitude, longitude] }]
        )
      end

      after do
        Geocoder::Lookup::Test.reset
      end

      it { is_expected.to have_attributes(longitude:, latitude:) }
    end

    context 'when the postcode is not found' do
      let(:postcode) { 'SE99 1AA' }

      before do
        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => nil }]
        )
      end

      after do
        Geocoder::Lookup::Test.reset
      end

      it { is_expected.to be_nil }
    end
  end

  describe '.point' do
    let(:latitude) { 50.0 }
    let(:longitude) { 1.0 }

    let(:point) do
      described_class.point(latitude:, longitude:)
    end

    it 'returns point which can be saved to st_point database column' do
      expect(point).to be_a(RGeo::Feature::Point)
    end

    it 'returns point built from latitude and longitude' do
      expect(point.latitude).to eq(latitude)
      expect(point.longitude).to eq(longitude)
    end

    context 'when latitude is nil' do
      let(:latitude) { nil }

      it 'returns nil' do
        expect(point).to be_nil
      end
    end

    context 'when latitude is empty string' do
      let(:latitude) { '' }

      it 'returns nil' do
        expect(point).to be_nil
      end
    end

    context 'when longitude is nil' do
      let(:longitude) { nil }

      it 'returns nil' do
        expect(point).to be_nil
      end
    end

    context 'when longitude is empty string' do
      let(:longitude) { '' }

      it 'returns nil' do
        expect(point).to be_nil
      end
    end
  end
end
