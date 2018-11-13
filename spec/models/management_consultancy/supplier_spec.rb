require 'rails_helper'

module ManagementConsultancy
  RSpec.describe Supplier, type: :model do
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

    describe '#services_in_lot' do
      let(:supplier) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      let(:service_1_1) { Service.find_by(code: '1.1') }
      let(:service_1_2) { Service.find_by(code: '1.2') }
      let(:service_2_1) { Service.find_by(code: '2.1') }

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
  end
end
