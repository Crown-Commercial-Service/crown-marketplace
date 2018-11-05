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

  it 'can be associated with many facilities management service offerings' do
    offering1 = supplier.service_offerings.build
    offering2 = supplier.service_offerings.build
    expect(supplier.service_offerings).to eq([offering1, offering2])
  end

  describe '.available_in_lot' do
    let(:supplier1) { create(:facilities_management_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:facilities_management_supplier, name: 'Supplier 2') }

    before do
      supplier1.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC1')
      supplier1.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC2')
      supplier1.regional_availabilities.create!(lot_number: '1b', region_code: 'UKD1')

      supplier2.regional_availabilities.create!(lot_number: '1b', region_code: 'UKC2')
      supplier2.regional_availabilities.create!(lot_number: '1b', region_code: 'UKD1')
      supplier2.regional_availabilities.create!(lot_number: '1c', region_code: 'UKD3')
    end

    it 'returns suppliers with availability in lot 1a' do
      expect(described_class.available_in_lot('1a')).to contain_exactly(supplier1)
    end

    it 'returns suppliers with availability in lot 1b' do
      expect(described_class.available_in_lot('1b')).to contain_exactly(supplier1, supplier2)
    end

    it 'returns suppliers with availability in lot 1c' do
      expect(described_class.available_in_lot('1c')).to contain_exactly(supplier2)
    end
  end

  describe '.available_in_lot_and_regions' do
    let(:supplier1) { create(:facilities_management_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:facilities_management_supplier, name: 'Supplier 2') }

    before do
      supplier1.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC1')
      supplier1.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC2')
      supplier1.regional_availabilities.create!(lot_number: '1a', region_code: 'UKD1')

      supplier2.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC1')
      supplier2.regional_availabilities.create!(lot_number: '1b', region_code: 'UKC2')
    end

    it 'returns suppliers with availability in lot and all specified regions' do
      expect(described_class.available_in_lot_and_regions('1a', ['UKC1', 'UKD1']))
        .to contain_exactly(supplier1)
    end
  end
end
