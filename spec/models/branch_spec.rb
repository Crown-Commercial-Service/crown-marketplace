require 'rails_helper'

RSpec.describe Branch, type: :model do
  subject(:branch) { supplier.branches.build(postcode: 'SW1A 1AA') }

  let(:supplier) { Supplier.create!(name: 'Supplier') }

  it { is_expected.to be_valid }

  it 'is not valid if postcode is blank' do
    branch.postcode = ''
    expect(branch).not_to be_valid
  end

  context 'when postcode is nonsense' do
    before do
      branch.postcode = 'nonsense'
    end

    it { is_expected.not_to be_valid }

    it 'has a sensible error message' do
      branch.validate
      expect(branch.errors).to include(postcode: include('is not a valid postcode'))
    end
  end

  context 'when three branches exist in different locations' do
    let(:point_factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

    let!(:london_1) do
      supplier.branches.create!(
        postcode: 'E1 6EA', location: point_factory.point(51.5201, -0.0759)
      )
    end
    let!(:london_2) do
      supplier.branches.create!(
        postcode: 'EC1V 9HE', location: point_factory.point(51.5263, -0.0858)
      )
    end
    let!(:edinburgh) do
      supplier.branches.create!(
        postcode: 'EH7 4DX', location: point_factory.point(55.9619, -3.1953)
      )
    end

    let(:shoreditch) { point_factory.point(51.5255, -0.0587) }

    it 'includes nearby branches' do
      expect(Branch.near(shoreditch, within_metres: 10000)).to include(london_1, london_2)
    end

    it 'excludes far away branches' do
      expect(Branch.near(shoreditch, within_metres: 10000)).not_to include(edinburgh)
    end
  end
end
