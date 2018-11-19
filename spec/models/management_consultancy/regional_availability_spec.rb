require 'rails_helper'

RSpec.describe ManagementConsultancy::RegionalAvailability, type: :model do
  subject(:regional_availability) { build(:management_consultancy_regional_availability) }

  it { is_expected.to be_valid }

  it 'is not valid if lot_number is blank' do
    regional_availability.lot_number = ''
    expect(regional_availability).not_to be_valid
  end

  it 'is not valid if region_code is blank' do
    regional_availability.region_code = ''
    expect(regional_availability).not_to be_valid
  end

  it 'can be associated with one management consultancy supplier' do
    supplier = build(:management_consultancy_supplier)
    availability = supplier.regional_availabilities.build
    expect(availability.supplier).to eq(supplier)
  end
end
