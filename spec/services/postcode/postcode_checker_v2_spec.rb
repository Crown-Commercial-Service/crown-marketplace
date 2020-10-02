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
    let(:postcode_postcode_structure) { { full_postcode: 'EC1A 2AT', out_code: 'EC1A' } }
    let(:empty_results) { ActiveRecord::Result.new(['code', 'region'], []) }
    let(:full_postcode_results) { empty_results }
    let(:out_code_results) { ActiveRecord::Result.new(['code', 'region'], [['UKI3', 'Inner London - West'], ['UKI4', 'Inner London - East']]) }

    before do
      allow(described_class).to receive(:execute_find_region_query).and_return(empty_results)
      allow(described_class).to receive(:execute_find_region_query).with(postcode_postcode_structure[:full_postcode].delete(' ')).and_return(full_postcode_results)
      allow(described_class).to receive(:execute_find_region_query).with(postcode_postcode_structure[:out_code]).and_return(out_code_results)
    end

    context 'when a region can be found from the postcode' do
      let(:full_postcode_results) { ActiveRecord::Result.new(['code', 'region'], [['UKI3', 'Inner London - West']]) }

      it 'returns the single region' do
        expect(described_class.extract_regions(postcode_postcode_structure)).to eq [{ code: 'UKI3', region: 'Inner London - West' }]
      end
    end

    context 'when a region cannot be found from the postcode' do
      before { described_class.extract_regions(postcode_postcode_structure) }

      it 'does the query with the out_code' do
        expect(described_class).to have_received(:execute_find_region_query).with(postcode_postcode_structure[:out_code])
      end
    end

    context 'when multiple regions can be found from the postcode with some nil' do
      let(:out_code_results) { ActiveRecord::Result.new(['code', 'region'], [['UKI3', nil], [nil, 'Inner London - West'], ['UKI4', 'Inner London - East']]) }

      it 'returns the regions formatted correctly' do
        expect(described_class.extract_regions(postcode_postcode_structure)).to eq [{ code: 'UKI4', region: 'Inner London - East' }]
      end
    end

    context 'when full postocde results returns an invalid region' do
      let(:full_postcode_results) { ActiveRecord::Result.new(['code', 'region'], [['*N_A', nil]]) }

      it 'usues the outcode the get the results' do
        expect(described_class.extract_regions(postcode_postcode_structure)).to eq [{ code: 'UKI3', region: 'Inner London - West' }, { code: 'UKI4', region: 'Inner London - East' }]
      end
    end
  end
end
