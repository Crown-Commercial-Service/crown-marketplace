require 'rails_helper'

RSpec.describe ManagementConsultancy::Supplier, type: :model do
  subject(:supplier) { build(:management_consultancy_supplier) }

  it { is_expected.to be_valid }

  it 'is not valid if name is blank' do
    supplier.name = ''
    expect(supplier).not_to be_valid
  end

  describe '.available_in_lot' do
    let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:management_consultancy_supplier, name: 'Supplier 2') }

    before do
      supplier1.service_offerings.create!(lot_number: '1', service_code: '1.1')
      supplier1.service_offerings.create!(lot_number: '1', service_code: '1.2')
      supplier1.service_offerings.create!(lot_number: '2', service_code: '2.1')

      supplier2.service_offerings.create!(lot_number: '2', service_code: '2.2')
      supplier2.service_offerings.create!(lot_number: '2', service_code: '2.3')
      supplier2.service_offerings.create!(lot_number: '3', service_code: '3.1')
    end

    it 'returns suppliers with availability in lot 1' do
      expect(described_class.available_in_lot('1')).to contain_exactly(supplier1)
    end

    it 'returns suppliers with availability in lot 2' do
      expect(described_class.available_in_lot('2')).to contain_exactly(supplier1, supplier2)
    end

    it 'returns suppliers with availability in lot 3' do
      expect(described_class.available_in_lot('3')).to contain_exactly(supplier2)
    end
  end

  describe '.offering_services' do
    let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:management_consultancy_supplier, name: 'Supplier 2') }

    before do
      supplier1.service_offerings.create!(lot_number: '1', service_code: '1.1')
      supplier1.service_offerings.create!(lot_number: '1', service_code: '1.2')
      supplier1.service_offerings.create!(lot_number: '2', service_code: '2.1')

      supplier2.service_offerings.create!(lot_number: '2', service_code: '2.2')
      supplier2.service_offerings.create!(lot_number: '2', service_code: '2.3')
      supplier2.service_offerings.create!(lot_number: '3', service_code: '3.1')
    end

    it 'returns suppliers with availability in lot 1' do
      expect(described_class.offering_services('1', ['1.2'])).to contain_exactly(supplier1)
      expect(described_class.offering_services('1', ['1.1', '1.2'])).to contain_exactly(supplier1)
    end

    it 'only returns suppliers that offer all services' do
      expect(described_class.offering_services('1', ['1.3'])).to be_empty
      expect(described_class.offering_services('1', ['1.1', '1.3'])).to be_empty
    end

    it 'ignores services when there is a lot mismatch' do
      expect(described_class.offering_services('1', ['1.1'])).to contain_exactly(supplier1)
      expect(described_class.offering_services('2', ['1.1'])).to be_empty
    end
  end

  describe '#services_in_lot' do
    let(:supplier) { create(:management_consultancy_supplier, name: 'Supplier 1') }

    let(:service_1_1) { ManagementConsultancy::Service.find_by(code: '1.1') }
    let(:service_1_2) { ManagementConsultancy::Service.find_by(code: '1.2') }
    let(:service_2_1) { ManagementConsultancy::Service.find_by(code: '2.1') }

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
        lot_number: service_2_1.lot_number,
        service_code: service_2_1.code
      )
    end

    it 'returns services in lot 1' do
      expect(supplier.services_in_lot('1')).to contain_exactly(service_1_1, service_1_2)
    end

    it 'returns services in lot 2' do
      expect(supplier.services_in_lot('2')).to contain_exactly(service_2_1)
    end
  end

  describe '.supplying_regions' do
    let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:management_consultancy_supplier, name: 'Supplier 2') }
    let(:supplier3) { create(:management_consultancy_supplier, name: 'Supplier 3') }

    before do
      supplier1.regional_availabilities.create!(
        lot_number: '1', region_code: 'UKC1', expenses_required: false
      )
      supplier1.regional_availabilities.create!(
        lot_number: '1', region_code: 'UKC2', expenses_required: false
      )
      supplier2.regional_availabilities.create!(
        lot_number: '2', region_code: 'UKC1', expenses_required: false
      )
      supplier3.regional_availabilities.create!(
        lot_number: '1', region_code: 'UKC2', expenses_required: false
      )
    end

    it 'returns suppliers offering services in lot and regions' do
      expect(described_class.supplying_regions('1', ['UKC1']))
        .to contain_exactly(supplier1)
    end

    it 'does not include suppliers offering services in a different lot' do
      expect(described_class.supplying_regions('1', ['UKC1']))
        .not_to include(supplier2)
    end

    it 'only includes suppliers offering services in all specified regions' do
      expect(described_class.supplying_regions('1', ['UKC1', 'UKC2']))
        .to contain_exactly(supplier1)
    end

    it 'returns multiple matching suppliers' do
      expect(described_class.supplying_regions('1', ['UKC2']))
        .to contain_exactly(supplier1, supplier3)
    end
  end

  describe '.delete_all_with_dependents' do
    let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:management_consultancy_supplier, name: 'Supplier 2') }

    before do
      supplier1.regional_availabilities.create!(
        lot_number: '1', region_code: 'UKC1', expenses_required: false
      )
      supplier1.service_offerings.create!(lot_number: '1', service_code: '1.1')

      supplier2.regional_availabilities.create!(
        lot_number: '2', region_code: 'UKC2', expenses_required: false
      )
      supplier2.service_offerings.create!(lot_number: '2', service_code: '2.1')
    end

    it 'deletes all regional availabilities' do
      described_class.delete_all_with_dependents

      expect(ManagementConsultancy::RegionalAvailability.count).to eq(0)
    end

    it 'deletes all service offerings' do
      described_class.delete_all_with_dependents

      expect(ManagementConsultancy::ServiceOffering.count).to eq(0)
    end

    it 'deletes all suppliers' do
      described_class.delete_all_with_dependents

      expect(described_class.count).to eq(0)
    end
  end
end
