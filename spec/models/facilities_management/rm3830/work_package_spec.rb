require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::WorkPackage do
  subject(:packages) { described_class.all }

  let(:first_package) { packages.first }
  let(:all_codes) { described_class.all.map(&:code) }

  it 'loads work packages from CSV' do
    expect(packages.count).to eq(15)
  end

  it 'populates attributes of first work package' do
    expect(first_package.code).to eq('A')
    expect(first_package.name).to eq('Contract management')
  end

  it 'only has unique codes' do
    expect(all_codes.uniq).to contain_exactly(*all_codes)
  end

  it 'all have names' do
    expect(packages.select { |p| p.name.blank? }).to be_empty
  end
end
