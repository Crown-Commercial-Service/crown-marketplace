require 'rails_helper'

RSpec.describe LegalServices::Supplier, type: :model do
  subject(:supplier) { build(:legal_services_supplier) }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
    expect(supplier).not_to be_valid
  end

  describe '.available_in_lot' do
    let(:supplier1) { create(:legal_services_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:legal_services_supplier, name: 'Supplier 2') }

    before do
      supplier1.service_offerings.create!(lot_number: '1', service_code: 'WPSLS.1.1')
      supplier1.service_offerings.create!(lot_number: '1', service_code: 'WPSLS.1.2')
      supplier1.service_offerings.create!(lot_number: '2a', service_code: 'WPSLS.2a.1')

      supplier2.service_offerings.create!(lot_number: '2a', service_code: 'WPSLS.2a.1')
      supplier2.service_offerings.create!(lot_number: '3', service_code: 'WPSLS.3.1')
      supplier2.service_offerings.create!(lot_number: '4', service_code: 'WPSLS.4.1')
    end

    it 'returns suppliers with availability in lot 1' do
      expect(described_class.available_in_lot('1')).to contain_exactly(supplier1)
    end

    it 'returns suppliers with availability in lot 2a' do
      expect(described_class.available_in_lot('2a')).to contain_exactly(supplier1, supplier2)
    end

    it 'returns suppliers with availability in lot 3' do
      expect(described_class.available_in_lot('3')).to contain_exactly(supplier2)
    end
  end

  describe '.offering_services' do
    let(:supplier1) { create(:legal_services_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:legal_services_supplier, name: 'Supplier 2') }

    before do
      supplier1.service_offerings.create!(lot_number: '1', service_code: 'WPSLS.1.1')
      supplier1.service_offerings.create!(lot_number: '1', service_code: 'WPSLS.1.2')
      supplier1.service_offerings.create!(lot_number: '2a', service_code: 'WPSLS.2a.1')

      supplier2.service_offerings.create!(lot_number: '2a', service_code: 'WPSLS.2a.1')
      supplier2.service_offerings.create!(lot_number: '3', service_code: 'WPSLS.3.1')
      supplier2.service_offerings.create!(lot_number: '4', service_code: 'WPSLS.4.1')
    end

    it 'returns suppliers with availability in lot 1' do
      expect(described_class.offering_services('1', ['WPSLS.1.1'])).to contain_exactly(supplier1)
      expect(described_class.offering_services('1', ['WPSLS.1.1', 'WPSLS.1.2'])).to contain_exactly(supplier1)
    end

    it 'only returns suppliers that offer all services' do
      expect(described_class.offering_services('1', ['WPSLS.1.3'])).to be_empty
      expect(described_class.offering_services('1', ['WPSLS.1.1', 'WPSLS.1.3'])).to be_empty
    end

    it 'ignores services when there is a lot mismatch' do
      expect(described_class.offering_services('1', ['WPSLS.1.1'])).to contain_exactly(supplier1)
      expect(described_class.offering_services('2a', ['WPSLS.1.1'])).to be_empty
    end
  end

  describe '.offering_services_in_regions' do
    let(:supplier1) do
      create(:legal_services_supplier, name: 'Supplier 1')
    end
    let(:supplier2) do
      create(:legal_services_supplier, name: 'Supplier 2')
    end
    let(:supplier3) do
      create(:legal_services_supplier, name: 'Supplier 3')
    end
    let(:supplier4) do
      create(:legal_services_supplier, name: 'Supplier 3')
    end

    before do
      supplier1.service_offerings.create!(
        lot_number: '1', service_code: 'WPSLS.1.1'
      )
      supplier1.service_offerings.create!(
        lot_number: '1', service_code: 'WPSLS.1.2'
      )
      supplier1.service_offerings.create!(
        lot_number: '2a', service_code: 'WPSLS.2a.1'
      )
      supplier2.service_offerings.create!(
        lot_number: '1', service_code: 'WPSLS.1.2'
      )
      supplier3.service_offerings.create!(
        lot_number: '2a', service_code: 'WPSLS.2a.1'
      )
      supplier4.service_offerings.create!(
        lot_number: '1', service_code: 'WPSLS.1.1'
      )
      supplier1.regional_availabilities.create!(region_code: 'UKC')
      supplier2.regional_availabilities.create!(region_code: 'UKD')
      supplier3.regional_availabilities.create!(region_code: 'UKC')
      supplier4.regional_availabilities.create!(region_code: 'UKC')
    end

    it 'returns suppliers with availability in lot and regions' do
      expect(described_class.offering_services_in_regions('1', ['WPSLS.1.1'], nil, ['UKC']))
        .to contain_exactly(supplier1, supplier4)
    end
  end

  describe '#services_in_lot' do
    let(:supplier) { create(:legal_services_supplier, name: 'Supplier 1') }

    let(:service_1_1) { LegalServices::Service.find_by(code: 'WPSLS.1.1') }
    let(:service_1_2) { LegalServices::Service.find_by(code: 'WPSLS.1.2') }
    let(:service_3_1) { LegalServices::Service.find_by(code: 'WPSLS.3.1') }

    before do
      supplier.service_offerings.create!(
        lot_number: service_1_1.lot_number,
        service_code: service_1_1.code
      )
      supplier.service_offerings.create!(
        lot_number: service_1_2.lot_number,
        service_code: service_1_2.code
      )
      supplier.service_offerings.create!(
        lot_number: service_3_1.lot_number,
        service_code: service_3_1.code
      )
    end

    it 'returns services in lot 1' do
      expect(supplier.services_in_lot('1')).to contain_exactly(service_1_1, service_1_2)
    end

    it 'returns services in lot 3' do
      expect(supplier.services_in_lot('3')).to contain_exactly(service_3_1)
    end
  end

  describe '.supplying_regions' do
    let(:supplier1) { create(:legal_services_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:legal_services_supplier, name: 'Supplier 2') }
    let(:supplier3) { create(:legal_services_supplier, name: 'Supplier 3') }

    before do
      supplier1.regional_availabilities.create!(region_code: 'UKC')
      supplier1.regional_availabilities.create!(region_code: 'UKD')
      supplier2.regional_availabilities.create!(region_code: 'UKC')
      supplier3.regional_availabilities.create!(region_code: 'UKD')
    end

    it 'returns suppliers offering services in the selected regions' do
      expect(described_class.supplying_regions(['UKC'])).to contain_exactly(supplier1, supplier2)
    end

    it 'only includes suppliers offering services in all specified regions' do
      expect(described_class.supplying_regions(['UKC', 'UKD'])).to contain_exactly(supplier1)
    end

    it 'returns multiple matching suppliers' do
      expect(described_class.supplying_regions(['UKD']))
        .to contain_exactly(supplier1, supplier3)
    end
  end

  describe '.delete_all_with_dependents' do
    let(:supplier1) { create(:legal_services_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:legal_services_supplier, name: 'Supplier 2') }

    before do
      supplier1.regional_availabilities.create!(region_code: 'UKC')
      supplier1.service_offerings.create!(lot_number: '1', service_code: 'WPSLS.1.1')
      supplier2.regional_availabilities.create!(region_code: 'UKD')
      supplier2.service_offerings.create!(lot_number: '2a', service_code: 'WPSLS.2a.1')
    end

    it 'deletes all regional availabilities' do
      described_class.delete_all_with_dependents

      expect(LegalServices::RegionalAvailability.count).to eq(0)
    end

    it 'deletes all service offerings' do
      described_class.delete_all_with_dependents

      expect(LegalServices::ServiceOffering.count).to eq(0)
    end

    it 'deletes all suppliers' do
      described_class.delete_all_with_dependents

      expect(described_class.count).to eq(0)
    end
  end
end
