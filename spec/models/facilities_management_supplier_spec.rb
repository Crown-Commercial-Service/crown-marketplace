require 'rails_helper'

RSpec.describe FacilitiesManagementSupplier, type: :model do
  subject(:supplier) { build(:facilities_management_supplier) }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
    expect(supplier).not_to be_valid
  end

  it 'is not valid if contact_name is blank' do
    supplier.contact_name = ''
    expect(supplier).not_to be_valid
  end

  it 'is not valid if contact_email is blank' do
    supplier.contact_email = ''
    expect(supplier).not_to be_valid
  end

  it 'is not valid if telephone_number is blank' do
    supplier.telephone_number = ''
    expect(supplier).not_to be_valid
  end

  it 'can be associated with many facilities management regional availabilities' do
    availability1 = supplier.regional_availabilities.build
    availability2 = supplier.regional_availabilities.build
    expect(supplier.regional_availabilities).to eq([availability1, availability2])
  end
end
