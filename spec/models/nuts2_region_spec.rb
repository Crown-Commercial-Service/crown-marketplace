require 'rails_helper'

RSpec.describe Nuts2Region, type: :model do
  subject(:region) { described_class.find_by(code: 'UKM6') }

  it 'has a code and a name' do
    expect(region)
      .to have_attributes(code: 'UKM6', name: 'Highlands and Islands')
  end

  it 'belongs to a NUTS 1 region' do
    expect(region.nuts1_region)
      .to have_attributes(code: 'UKM', name: 'Scotland')
  end

  it 'has many NUTS 3 regions' do
    expect(region.nuts3_regions)
      .to have_attributes(length: 6)
  end

  describe '.all_codes' do
    let(:regions) { described_class.all }
    let(:first_region) { regions.first }

    it 'returns codes for all regions' do
      expect(described_class.all_codes.count).to eq(regions.count)
      expect(described_class.all_codes.first).to eq(first_region.code)
    end
  end
end
