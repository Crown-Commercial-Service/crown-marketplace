require 'rails_helper'

RSpec.describe Postcode::PostcodeCheckerV2 do
  describe '#find_region' do
    context 'when region cannot be found for postcode' do
      it 'returns all Nuts2Region regions' do
        expect(described_class.find_region('AB1 2CD').count).to eq Nuts2Region.all.count
      end
    end
  end
end
