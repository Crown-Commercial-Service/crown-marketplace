require 'rails_helper'

RSpec.describe FacilitiesManagement::RegionalAvailability, type: :model do
  subject(:regional_availability) { build(:facilities_management_regional_availability) }

  it { is_expected.to be_valid }

  it 'is not valid if lot_number is blank' do
    regional_availability.lot_number = ''
    expect(regional_availability).not_to be_valid
  end

  it 'is not valid if region_code is blank' do
    regional_availability.region_code = ''
    expect(regional_availability).not_to be_valid
  end

  it 'can be associated with one facilities management supplier' do
    supplier = build(:facilities_management_supplier)
    availability = supplier.regional_availabilities.build
    expect(availability.supplier).to eq(supplier)
  end
end
