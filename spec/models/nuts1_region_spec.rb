require 'rails_helper'

RSpec.describe Nuts1Region, type: :model do
  subject(:region) { described_class.find_by(code: 'UKM') }

  it 'has a code and a name' do
    expect(region)
      .to have_attributes(code: 'UKM', name: 'Scotland')
  end

  it 'has many NUTS 2 regions' do
    expect(region.nuts2_regions)
      .to have_attributes(length: 4)
  end
end
