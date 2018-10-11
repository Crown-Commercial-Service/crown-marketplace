require 'rails_helper'

RSpec.describe Branch, type: :model do
  subject(:branch) do
    supplier.branches.build(
      postcode: 'SW1A 1AA',
      location: Geocoding.point(latitude: 50.0, longitude: 1.0),
      telephone_number: '020 7946 0000',
      contact_name: 'Joe Bloggs',
      contact_email: 'joe.bloggs@example.com'
    )
  end

  let(:supplier) { Supplier.create!(name: 'Supplier') }

  it { is_expected.to be_valid }

  it 'is not valid if postcode is blank' do
    branch.postcode = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if location is blank' do
    branch.location = nil
    expect(branch).not_to be_valid
  end

  it 'is not valid if telephone_number is blank' do
    branch.telephone_number = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if contact_name is blank' do
    branch.contact_name = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if contact_email is blank' do
    branch.contact_email = ''
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
    let!(:london_1) do
      supplier.branches.create!(
        postcode: 'E1 6EA',
        telephone_number: '020 7946 0001',
        contact_name: 'John Smiths',
        contact_email: 'john.smith@example.com',
        location: Geocoding.point(latitude: 51.5201, longitude: -0.0759)
      )
    end
    let!(:london_2) do
      supplier.branches.create!(
        postcode: 'EC1V 9HE',
        telephone_number: '020 7946 0002',
        contact_name: 'Ann Jones',
        contact_email: 'ann.jones@example.com',
        location: Geocoding.point(latitude: 51.5263, longitude: -0.0858)
      )
    end
    let!(:edinburgh) do
      supplier.branches.create!(
        postcode: 'EH7 4DX',
        telephone_number: '020 7946 0003',
        contact_name: 'Clare Francis',
        contact_email: 'clare.francis@example.com',
        location: Geocoding.point(latitude: 55.9619, longitude: -3.1953)
      )
    end

    let(:shoreditch) { Geocoding.point(latitude: 51.5255, longitude: -0.0587) }

    it 'includes nearby branches' do
      expect(Branch.near(shoreditch, within_metres: 10000)).to include(london_1, london_2)
    end

    it 'excludes far away branches' do
      expect(Branch.near(shoreditch, within_metres: 10000)).not_to include(edinburgh)
    end
  end
end
