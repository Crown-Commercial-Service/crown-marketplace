require 'rails_helper'

RSpec.describe FacilitiesManagementRegion, type: :model do
  describe 'all' do
    it 'has 74 regions' do
      expect(described_class.all)
        .to have_attributes(length: 74)
    end
  end

  describe 'a NUTS 2 derived region' do
    subject(:region) { described_class.find_by(code: 'UKD3') }

    it 'has a code and a name' do
      expect(region)
        .to have_attributes(code: 'UKD3', name: 'Greater Manchester')
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
end
