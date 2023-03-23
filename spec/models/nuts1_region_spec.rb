require 'rails_helper'

RSpec.describe Nuts1Region do
  subject(:region) { described_class.find_by(code: 'UKM') }

  let(:all_codes) { described_class.all.map(&:code) }

  it 'has a code and a name' do
    expect(region)
      .to have_attributes(code: 'UKM', name: 'Scotland')
  end

  it 'only has unique codes' do
    expect(all_codes.uniq).to match_array(all_codes)
  end

  it 'has many NUTS 2 regions' do
    expect(region.nuts2_regions)
      .to have_attributes(length: 4)
  end

  describe '.all_with_overseas' do
    subject(:region) { described_class.all_with_overseas.last }

    it 'has the overseas reagion at the end' do
      expect(region.code).to eq 'OS0'
      expect(region.name).to eq 'Overseas'
    end
  end
end
