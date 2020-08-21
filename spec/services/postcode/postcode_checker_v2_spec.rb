require 'rails_helper'

RSpec.describe Postcode::PostcodeCheckerV2 do
  describe '#find_region' do
    context 'when region cannot be found for postcode' do
      it 'returns all Nuts2Region regions' do
        expect(described_class.find_region('AB1 2CD').count).to eq 73
      end
    end
  end

  describe '#extract_regions' do
    context 'when a region can be found for a postcode' do
      it 'returns all the regions formatted properly' do
        results = ActiveRecord::Result.new(['code', 'region'], [['UKL22', 'Cardiff and Vale of Glamorgan'], ['UKM50', 'Aberdeen and Aberdeenshire']])

        expect(described_class.extract_regions(results)).to eq [{ code: 'UKL22', region: 'Cardiff and Vale of Glamorgan' }, { code: 'UKM50', region: 'Aberdeen and Aberdeenshire' }]
      end
    end

    context 'when regions can be found but some only have codes' do
      it 'returns only the complete regions formatted properly' do
        results = ActiveRecord::Result.new(['code', 'region'], [['UKM50', nil], [nil, 'Aberdeen and Aberdeenshire'], ['UKL22', 'Cardiff and Vale of Glamorgan']])

        expect(described_class.extract_regions(results)).to eq [{ code: 'UKL22', region: 'Cardiff and Vale of Glamorgan' }]
      end
    end
  end
end
