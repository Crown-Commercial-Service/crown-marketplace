require 'rails_helper'

RSpec.describe ManagementConsultancy::RegionalAvailability, type: :model do
  subject(:regional_availability) { build(:management_consultancy_regional_availability) }

  it { is_expected.to be_valid }

  it 'is not valid if lot_number is blank' do
    regional_availability.lot_number = ''
    expect(regional_availability).not_to be_valid
  end

  it 'is not valid if lot_number is not in list of all lot numbers' do
    regional_availability.lot_number = 'invalid-number'
    expect(regional_availability).not_to be_valid
    expect(regional_availability.errors[:lot_number]).to include('is not included in the list')
  end

  it 'is not valid if region_code is blank' do
    regional_availability.region_code = ''
    expect(regional_availability).not_to be_valid
  end

  it 'is not valid if region_code is not in list of all region codes' do
    regional_availability.region_code = 'invalid-code'
    expect(regional_availability).not_to be_valid
    expect(regional_availability.errors[:region_code]).to include('is not included in the list')
  end

  it 'can be associated with one management consultancy supplier' do
    supplier = build(:management_consultancy_supplier)
    availability = supplier.regional_availabilities.build
    expect(availability.supplier).to eq(supplier)
  end
end
