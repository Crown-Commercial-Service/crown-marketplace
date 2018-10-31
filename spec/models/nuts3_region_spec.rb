require 'rails_helper'

RSpec.describe Nuts3Region, type: :model do
  subject(:region) { described_class.find_by(code: 'UKL12') }

  it 'has a code and a name' do
    expect(region)
      .to have_attributes(code: 'UKL12', name: 'Gwynedd')
  end

  it 'belongs to a NUTS 2 region' do
    expect(region.nuts2_region)
      .to have_attributes(code: 'UKL1', name: 'West Wales')
  end

  it 'belongs to a NUTS 1 region' do
    expect(region.nuts1_region)
      .to have_attributes(code: 'UKL', name: 'Wales')
  end
end
