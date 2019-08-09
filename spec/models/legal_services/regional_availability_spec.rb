require 'rails_helper'

RSpec.describe LegalServices::RegionalAvailability, type: :model do
  subject(:regional_availability) { build(:legal_services_regional_availability) }

  it { is_expected.to be_valid }

  it 'is not valid if region code is blank' do
    regional_availability.region_code = ''
    expect(regional_availability).not_to be_valid
  end

  it 'is not valid if region_code is not in list of all region codes' do
    regional_availability.region_code = 'invalid-number'
    expect(regional_availability).not_to be_valid
    expect(regional_availability.errors[:region_code]).to include('is not included in the list')
  end

  it 'is not valid if availability exists for same region_code & supplier' do
    regional_availability.save!
    new_availability = build(
      :legal_services_regional_availability,
      supplier: regional_availability.supplier,
      region_code: regional_availability.region_code
    )
    expect(new_availability).not_to be_valid
    expect(new_availability.errors[:region_code]).to include('has already been taken')
  end

  it 'is valid even if availability exists for same lot_number & region_code, but different supplier' do
    regional_availability.save!
    new_availability = build(
      :legal_services_regional_availability,
      supplier: build(:legal_services_supplier),
      region_code: regional_availability.region_code
    )
    expect(new_availability).to be_valid
  end

  it 'is valid even if availability exists for same lot_number & supplier, but different region_code' do
    regional_availability.save!
    new_availability = build(
      :legal_services_regional_availability,
      supplier: regional_availability.supplier,
      region_code: 'UKD'
    )
    expect(new_availability).to be_valid
  end

  it 'can be associated with one management consultancy supplier' do
    supplier = build(:legal_services_supplier)
    availability = supplier.regional_availabilities.build
    expect(availability.supplier).to eq(supplier)
  end
end
