require 'rails_helper'

RSpec.describe Nuts3Region do
  subject(:region) { described_class.find_by(code: 'UKL12') }

  let(:all_codes) { described_class.all.map(&:code) }

  it 'has a code and a name' do
    expect(region)
      .to have_attributes(code: 'UKL12', name: 'Gwynedd')
  end

  it 'only has unique codes' do
    expect(all_codes.uniq).to match_array(all_codes)
  end

  it 'belongs to a NUTS 2 region' do
    expect(region.nuts2_region)
      .to have_attributes(code: 'UKL1', name: 'West Wales and The Valleys')
  end

  it 'belongs to a NUTS 1 region' do
    expect(region.nuts1_region)
      .to have_attributes(code: 'UKL', name: 'Wales')
  end
end
