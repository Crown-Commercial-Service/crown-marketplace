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
      supplier1.service_offerings.create!(lot_number: 'MCF1.2', service_code: 'MCF1.2.1')
      supplier1.service_offerings.create!(lot_number: 'MCF1.2', service_code: 'MCF1.2.2')
      supplier1.service_offerings.create!(lot_number: 'MCF2.2', service_code: 'MCF2.2.1')

      supplier2.service_offerings.create!(lot_number: 'MCF2.2', service_code: 'MCF2.2.1')
      supplier2.service_offerings.create!(lot_number: 'MCF2.3', service_code: 'MCF2.3.1')
      supplier2.service_offerings.create!(lot_number: 'MCF2.4', service_code: 'MCF2.4.1')
    end

    it 'returns suppliers with availability in MCF lot 2' do
      expect(described_class.available_in_lot('MCF1.2')).to contain_exactly(supplier1)
    end

    it 'returns suppliers with availability in MCF 2 lot 2' do
      expect(described_class.available_in_lot('MCF2.2')).to contain_exactly(supplier1, supplier2)
    end

    it 'returns suppliers with availability in MCF2 lot 3' do
      expect(described_class.available_in_lot('MCF2.3')).to contain_exactly(supplier2)
    end
  end

  describe '.offering_services' do
    let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:management_consultancy_supplier, name: 'Supplier 2') }

    before do
      supplier1.service_offerings.create!(lot_number: 'MCF1.2', service_code: 'MCF1.2.1')
      supplier1.service_offerings.create!(lot_number: 'MCF1.2', service_code: 'MCF1.2.2')
      supplier1.service_offerings.create!(lot_number: 'MCF2.2', service_code: 'MCF2.2.1')

      supplier2.service_offerings.create!(lot_number: 'MCF2.2', service_code: 'MCF2.2.1')
      supplier2.service_offerings.create!(lot_number: 'MCF2.3', service_code: 'MCF2.3.1')
      supplier2.service_offerings.create!(lot_number: 'MCF2.4', service_code: 'MCF2.4.1')
    end

    it 'returns suppliers with availability in lot 1' do
      expect(described_class.offering_services('MCF1.2', ['MCF1.2.1'])).to contain_exactly(supplier1)
      expect(described_class.offering_services('MCF1.2', ['MCF1.2.1', 'MCF1.2.2'])).to contain_exactly(supplier1)
    end

    it 'only returns suppliers that offer all services' do
      expect(described_class.offering_services('MCF1.2', ['MCF1.2.3'])).to be_empty
      expect(described_class.offering_services('MCF1.2', ['MCF1.2.1', 'MCF1.2.3'])).to be_empty
    end

    it 'ignores services when there is a lot mismatch' do
      expect(described_class.offering_services('MCF1.2', ['MCF1.2.1'])).to contain_exactly(supplier1)
      expect(described_class.offering_services('MCF1.3', ['MCF1.2.1'])).to be_empty
    end
  end

  describe '.offering_services_in_regions' do
    let(:supplier1) do
      create(:management_consultancy_supplier, name: 'Supplier 1')
    end
    let(:supplier2) do
      create(:management_consultancy_supplier, name: 'Supplier 2')
    end
    let(:supplier3) do
      create(:management_consultancy_supplier, name: 'Supplier 3')
    end
    let(:supplier4) do
      create(:management_consultancy_supplier, name: 'Supplier 3')
    end

    before do
      supplier1.service_offerings.create!(
        lot_number: 'MCF1.2', service_code: 'MCF1.2.1'
      )
      supplier1.service_offerings.create!(
        lot_number: 'MCF1.2', service_code: 'MCF1.2.2'
      )
      supplier1.service_offerings.create!(
        lot_number: 'MCF1.3', service_code: 'MCF1.3.1'
      )
      supplier2.service_offerings.create!(
        lot_number: 'MCF1.2', service_code: 'MCF1.2.2'
      )
      supplier3.service_offerings.create!(
        lot_number: 'MCF1.3', service_code: 'MCF1.3.1'
      )
      supplier4.service_offerings.create!(
        lot_number: 'MCF1.2', service_code: 'MCF1.2.2'
      )
      supplier1.regional_availabilities.create!(
        lot_number: 'MCF1.2', region_code: 'UKC1', expenses_required: false
      )
      supplier2.regional_availabilities.create!(
        lot_number: 'MCF1.3', region_code: 'UKC2', expenses_required: false
      )
      supplier3.regional_availabilities.create!(
        lot_number: 'MCF1.2', region_code: 'UKC1', expenses_required: false
      )
      supplier4.regional_availabilities.create!(
        lot_number: 'MCF1.2', region_code: 'UKC1', expenses_required: true
      )
    end

    context 'when expenses are paid' do
      it 'returns suppliers with availability in lot and regions' do
        expect(described_class.offering_services_in_regions('MCF1.2', ['MCF1.2.2'], ['UKC1']))
          .to contain_exactly(supplier1, supplier4)
      end
    end

    context 'when expenses are not paid' do
      it 'excludes suppliers who require expenses' do
        expect(described_class.offering_services_in_regions('MCF1.2', ['MCF1.2.2'], ['UKC1'], false))
          .to contain_exactly(supplier1)
      end
    end
  end

  describe '#services_in_lot' do
    let(:supplier) { create(:management_consultancy_supplier, name: 'Supplier 1') }

    let(:service_1_1) { ManagementConsultancy::Service.find_by(code: 'MCF1.2.1') }
    let(:service_1_2) { ManagementConsultancy::Service.find_by(code: 'MCF1.2.2') }
    let(:service_2_1) { ManagementConsultancy::Service.find_by(code: 'MCF1.3.1') }

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
      expect(supplier.services_in_lot('MCF1.2')).to contain_exactly(service_1_1, service_1_2)
    end

    it 'returns services in lot 2' do
      expect(supplier.services_in_lot('MCF1.3')).to contain_exactly(service_2_1)
    end
  end

  describe '.supplying_regions' do
    let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:management_consultancy_supplier, name: 'Supplier 2') }
    let(:supplier3) { create(:management_consultancy_supplier, name: 'Supplier 3') }

    before do
      supplier1.regional_availabilities.create!(
        lot_number: 'MCF1.2', region_code: 'UKC1', expenses_required: false
      )
      supplier1.regional_availabilities.create!(
        lot_number: 'MCF1.2', region_code: 'UKC2', expenses_required: false
      )
      supplier2.regional_availabilities.create!(
        lot_number: 'MCF1.3', region_code: 'UKC1', expenses_required: false
      )
      supplier3.regional_availabilities.create!(
        lot_number: 'MCF1.2', region_code: 'UKC2', expenses_required: false
      )
    end

    it 'returns suppliers offering services in lot and regions' do
      expect(described_class.supplying_regions('MCF1.2', ['UKC1']))
        .to contain_exactly(supplier1)
    end

    it 'does not include suppliers offering services in a different lot' do
      expect(described_class.supplying_regions('MCF1.2', ['UKC1']))
        .not_to include(supplier2)
    end

    it 'only includes suppliers offering services in all specified regions' do
      expect(described_class.supplying_regions('MCF1.2', ['UKC1', 'UKC2']))
        .to contain_exactly(supplier1)
    end

    it 'returns multiple matching suppliers' do
      expect(described_class.supplying_regions('MCF1.2', ['UKC2']))
        .to contain_exactly(supplier1, supplier3)
    end
  end

  describe '.delete_all_with_dependents' do
    let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }
    let(:supplier2) { create(:management_consultancy_supplier, name: 'Supplier 2') }

    before do
      supplier1.regional_availabilities.create!(
        lot_number: 'MCF1.2', region_code: 'UKC1', expenses_required: false
      )
      supplier1.service_offerings.create!(lot_number: 'MCF1.2', service_code: 'MCF1.2.1')

      supplier2.regional_availabilities.create!(
        lot_number: 'MCF1.3', region_code: 'UKC2', expenses_required: false
      )
      supplier2.service_offerings.create!(lot_number: 'MCF1.3', service_code: 'MCF1.3.1')
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
