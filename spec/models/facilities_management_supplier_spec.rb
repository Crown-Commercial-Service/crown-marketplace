require 'rails_helper'

RSpec.describe FacilitiesManagementSupplier, type: :model do
  subject(:supplier) { build(:facilities_management_supplier) }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
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

    it 'eagerly loads service offerings to reduce number of queries' do
      suppliers = described_class.available_in_lot('1a')
      expect(suppliers.first.service_offerings).to be_loaded
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

    it 'eagerly loads service offerings to reduce number of queries' do
      suppliers = described_class.available_in_lot_and_regions('1a', ['UKC1', 'UKD1'])
      expect(suppliers.first.service_offerings).to be_loaded
    end
  end

  describe '.delete_all_with_dependents' do
    let(:supplier1) { create(:facilities_management_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:facilities_management_supplier, name: 'Supplier 2') }

    before do
      supplier1.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC1')
      supplier1.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC2')

      supplier2.regional_availabilities.create!(lot_number: '1a', region_code: 'UKC1')
    end

    it 'deletes all regional availabilities' do
      described_class.delete_all_with_dependents

      expect(FacilitiesManagementRegionalAvailability.count).to eq(0)
    end

    it 'deletes all service offerings' do
      described_class.delete_all_with_dependents

      expect(FacilitiesManagementServiceOffering.count).to eq(0)
    end

    it 'deletes all suppliers' do
      described_class.delete_all_with_dependents

      expect(described_class.count).to eq(0)
    end
  end

  describe '#services_by_work_package_in_lot' do
    let(:supplier) { create(:facilities_management_supplier, name: 'Supplier 1') }

    let(:service_a1) { FacilitiesManagement::Service.find_by(code: 'A.1') }
    let(:service_a2) { FacilitiesManagement::Service.find_by(code: 'A.2') }
    let(:service_b1) { FacilitiesManagement::Service.find_by(code: 'B.1') }

    let(:work_package_a) { FacilitiesManagement::WorkPackage.find_by(code: 'A') }
    let(:work_package_b) { FacilitiesManagement::WorkPackage.find_by(code: 'B') }
    let(:work_package_c) { FacilitiesManagement::WorkPackage.find_by(code: 'C') }

    let(:lot) { '1a' }
    let(:another_lot) { '1b' }

    let(:services) { supplier.services_by_work_package_in_lot(lot) }

    before do
      supplier.service_offerings.create!(lot_number: lot, service_code: 'A.1')
      supplier.service_offerings.create!(lot_number: lot, service_code: 'A.2')
      supplier.service_offerings.create!(lot_number: lot, service_code: 'B.1')
      supplier.service_offerings.create!(lot_number: another_lot, service_code: 'C.1')
    end

    it 'returns services grouped by work package' do
      expect(services[work_package_a]).to contain_exactly(service_a1, service_a2)
      expect(services[work_package_b]).to contain_exactly(service_b1)
    end

    it 'only includes service offerings in the specified lot' do
      expect(services.keys).to contain_exactly(work_package_a, work_package_b)
    end
  end
end
