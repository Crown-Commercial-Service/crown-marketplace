require 'rails_helper'

RSpec.describe FacilitiesManagement::Region do
  subject(:regions) { described_class.all }

  let(:all_codes) { described_class.all_codes }

  it 'only has unique codes' do
    expect(all_codes.uniq).to contain_exactly(*all_codes)
  end

  it 'all have names' do
    expect(regions.select { |r| r.name.blank? }).to be_empty
  end

  describe 'all' do
    it 'has 74 regions' do
      expect(regions)
        .to have_attributes(length: 74)
    end
  end

  describe 'a NUTS 2 derived region' do
    subject(:region) { described_class.find_by(code: 'UKD3') }

    it 'has a code and a name' do
      expect(region)
        .to have_attributes(code: 'UKD3', name: 'Greater Manchester')
    end

    it { is_expected.to be_nuts2 }
    it { is_expected.not_to be_nuts3 }

    it 'has a NUTS 1 code' do
      expect(region.nuts1_code).to eq('UKD')
    end

    it 'has a NUTS 1 region' do
      expect(region.nuts1_region)
        .to have_attributes(code: 'UKD', name: 'North West (England)')
    end

    it 'has a NUTS 2 code' do
      expect(region.nuts2_code).to eq('UKD3')
    end

    it 'has a NUTS 2 region' do
      expect(region.nuts2_region)
        .to have_attributes(code: 'UKD3', name: 'Greater Manchester')
    end

    it 'has no NUTS 3 code' do
      expect(region.nuts3_code).to be_nil
    end

    it 'has no NUTS 3 region' do
      expect(region.nuts3_region).to be_nil
    end
  end

  describe 'a NUTS 3 derived region' do
    subject(:region) { described_class.find_by(code: 'UKM65') }

    it 'has a code and a name' do
      expect(region)
        .to have_attributes(code: 'UKM65', name: 'Orkney Islands')
    end

    it { is_expected.not_to be_nuts2 }
    it { is_expected.to be_nuts3 }

    it 'has a NUTS 1 code' do
      expect(region.nuts1_code).to eq('UKM')
    end

    it 'has a NUTS 1 region' do
      expect(region.nuts1_region)
        .to have_attributes(code: 'UKM', name: 'Scotland')
    end

    it 'has a NUTS 2 code' do
      expect(region.nuts2_code).to eq('UKM6')
    end

    it 'has a NUTS 2 region' do
      expect(region.nuts2_region)
        .to have_attributes(code: 'UKM6', name: 'Highlands and Islands')
    end

    it 'has a NUTS 3 code' do
      expect(region.nuts3_code).to eq('UKM65')
    end

    it 'has a NUTS 3 region' do
      expect(region.nuts3_region)
        .to have_attributes(code: 'UKM65', name: 'Orkney Islands')
    end
  end

  describe '.all_codes' do
    let(:first_region) { regions.first }

    it 'returns codes for all regions' do
      expect(all_codes.count).to eq(regions.count)
      expect(all_codes.first).to eq(first_region.code)
    end
  end
end
