require 'rails_helper'

RSpec.describe Supplier::Framework do
  let(:supplier_framework) { create(:supplier_framework) }

  describe 'associations' do
    it { is_expected.to belong_to(:supplier) }
    it { is_expected.to belong_to(:framework) }

    it { is_expected.to have_one(:contact_detail) }
    it { is_expected.to have_one(:address) }

    it { is_expected.to have_many(:lots) }

    it 'has the supplier relationship' do
      expect(supplier_framework.supplier).to be_present
    end

    it 'has the framework relationship' do
      expect(supplier_framework.framework).to be_present
    end
  end

  describe 'uniqueness' do
    let(:supplier) { create(:supplier) }
    let(:framework) { create(:framework) }

    it 'raises an error if a record already exists for a supplier and framework' do
      create(:supplier_framework, supplier:, framework:)

      expect { create(:supplier_framework, supplier:, framework:) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe '.grouped_rates_for_lot' do
    let(:result) { supplier_framework.grouped_rates_for_lot(lot_id) }
    let(:lot_id) { 'RM6240.1a' }
    let(:supplier_framework_lot_a) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6240.1a') }
    let(:supplier_framework_lot_c) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6240.3') }

    let!(:lot_a_grouped_rates) do
      {
        1 => create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot_a, position_id: 1),
        2 => create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot_a, position_id: 2),
        3 => create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot_a, position_id: 3),
        4 => create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot_a, position_id: 4),
      }
    end
    let!(:lot_c_grouped_rates) do
      {
        1 => create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot_c, position_id: 1),
        2 => create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot_c, position_id: 2),
        3 => create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot_c, position_id: 3),
      }
    end

    context 'when we pass the lot and jurisdiction' do
      let(:lot_id) { 'RM6240.1a' }

      it 'returns the 4 grouped rates' do
        expect(result).to eq(lot_a_grouped_rates)
      end
    end

    context 'when we pass a lot with no rates' do
      let(:lot_id) { 'RM6240.2a' }

      it 'raises no method error' do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    context 'when we pass 3 for the lot' do
      let(:lot_id) { 'RM6240.3' }

      it 'returns the 3 grouped rates' do
        expect(result).to eq(lot_c_grouped_rates)
      end
    end
  end

  describe '.grouped_rates_for_lot_and_jurisdictions' do
    let(:result) { supplier_framework.grouped_rates_for_lot_and_jurisdictions(lot_id, jurisdiction_ids) }
    let(:lot_id) { 'RM6240.1a' }
    let(:jurisdiction_ids) { %w[AE AX] }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6240.1a') }
    let(:lot_grouped_rates) { [] }

    before do
      ae_jurisdiction = create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_lot, jurisdiction_id: 'AE')
      az_jurisdiction = create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_lot, jurisdiction_id: 'AX')

      lot_grouped_rates << create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: 1, jurisdiction: ae_jurisdiction)
      lot_grouped_rates << create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: 1, jurisdiction: az_jurisdiction)
      lot_grouped_rates << create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: 2, jurisdiction: az_jurisdiction)
      lot_grouped_rates << create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: 3, jurisdiction: ae_jurisdiction)
      lot_grouped_rates << create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, position_id: 3, jurisdiction: az_jurisdiction)
    end

    context 'when we pass a lot with no rates' do
      let(:lot_id) { 'RM6240.2a' }

      it 'raises no method error' do
        expect { result }.to raise_error(NoMethodError)
      end
    end

    context 'when all jurisdictions are passed' do
      it 'returns the 3 grouped rates' do
        expect(result).to eq(
          {
            1 => { 'AE' => lot_grouped_rates[0], 'AX' => lot_grouped_rates[1] },
            2 => { 'AX' => lot_grouped_rates[2] },
            3 => { 'AE' => lot_grouped_rates[3], 'AX' => lot_grouped_rates[4] }
          }
        )
      end
    end

    context 'when one jurisdiction is passed' do
      let(:jurisdiction_ids) { %w[AE] }

      it 'returns the 3 grouped rates' do
        expect(result).to eq(
          {
            1 => { 'AE' => lot_grouped_rates[0] },
            3 => { 'AE' => lot_grouped_rates[3] }
          }
        )
      end
    end

    context 'when a jurisdiction that is not done is passed' do
      let(:jurisdiction_ids) { %w[DE] }

      it 'returns the 3 grouped rates' do
        expect(result).to eq({})
      end
    end
  end

  describe '.with_lots' do
    let(:result) { described_class.with_lots(lot_id).pluck(:id) }
    let(:supplier_frameworks) { create_list(:supplier_framework, 4, framework_id: 'RM6240') }
    let(:supplier_framework_1_id) { supplier_frameworks[0].id }
    let(:supplier_framework_2_id) { supplier_frameworks[1].id }

    before do
      supplier_frameworks[2].update(enabled: false)

      create(:supplier_framework_lot, supplier_framework: supplier_frameworks[0], lot_id: 'RM6240.1a')
      create(:supplier_framework_lot, supplier_framework: supplier_frameworks[1], lot_id: 'RM6240.1a')
      create(:supplier_framework_lot, supplier_framework: supplier_frameworks[1], lot_id: 'RM6240.3')
      create(:supplier_framework_lot, supplier_framework: supplier_frameworks[2], lot_id: 'RM6240.1a')
      create(:supplier_framework_lot, supplier_framework: supplier_frameworks[3], lot_id: 'RM6240.1a', enabled: false)
      create(:supplier_framework_lot, supplier_framework: supplier_frameworks[3], lot_id: 'RM6240.3', enabled: false)
    end

    context 'when we pass the lot id' do
      let(:lot_id) { 'RM6240.1a' }

      it 'returns both suppliers' do
        expect(result).to contain_exactly(supplier_framework_1_id, supplier_framework_2_id)
      end
    end

    context 'when we pass a lot id neither supplier does' do
      let(:lot_id) { 'RM6240.2a' }

      it 'returns an emoty array' do
        expect(result).to be_empty
      end
    end

    context 'when we pass 3 for the lot id' do
      let(:lot_id) { 'RM6240.3' }

      it 'returns the second supplier' do
        expect(result).to contain_exactly(supplier_framework_2_id)
      end
    end
  end

  describe '.with_services' do
    let(:result) { described_class.with_services(service_ids).pluck(:id) }
    let(:supplier_frameworks) { create_list(:supplier_framework, 5, framework_id: 'RM6240') }
    let(:supplier_framework_1_id) { supplier_frameworks[0].id }
    let(:supplier_framework_2_id) { supplier_frameworks[1].id }

    before do
      supplier_frameworks[2].update(enabled: false)

      supplier_framework_1_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[0], lot_id: 'RM6240.1a')
      supplier_framework_2_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[1], lot_id: 'RM6240.1a')
      supplier_framework_2_lot_c = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[1], lot_id: 'RM6240.3')
      supplier_framework_3_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[2], lot_id: 'RM6240.1a')
      supplier_framework_4_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[3], lot_id: 'RM6240.1a', enabled: false)
      supplier_framework_4_lot_c = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[3], lot_id: 'RM6240.3', enabled: false)

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_1_lot_a, service_id: 'RM6240.1a.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6240.1a.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6240.1a.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_4_lot_a, service_id: 'RM6240.1a.1')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6240.1a.2')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6240.1a.2')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_4_lot_a, service_id: 'RM6240.1a.2')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_c, service_id: 'RM6240.3.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_4_lot_c, service_id: 'RM6240.3.1')
    end

    context 'when we pass a single service code' do
      let(:service_ids) { ['RM6240.1a.1'] }

      it 'returns both suppliers' do
        expect(result).to contain_exactly(supplier_framework_1_id, supplier_framework_2_id)
      end
    end

    context 'when we pass multiple service codes' do
      let(:service_ids) { ['RM6240.1a.1', 'RM6240.1a.2'] }

      it 'returns the second supplier' do
        expect(result).to contain_exactly(supplier_framework_2_id)
      end
    end

    context 'when we pass service codes neither supplier does' do
      let(:service_ids) { ['RM6240.2a.1'] }

      it 'returns an emoty array' do
        expect(result).to be_empty
      end
    end

    context 'when we pass 3.1 for the service' do
      let(:service_ids) { ['RM6240.3.1'] }

      it 'returns the second supplier' do
        expect(result).to contain_exactly(supplier_framework_2_id)
      end
    end
  end

  describe '.with_services_and_jurisdictions' do
    let(:result) { described_class.with_services_and_jurisdiction(service_ids, jurisdiction_ids).pluck(:id) }
    let(:supplier_frameworks) { create_list(:supplier_framework, 5, framework_id: 'RM6240') }
    let(:supplier_framework_1_id) { supplier_frameworks[0].id }
    let(:supplier_framework_2_id) { supplier_frameworks[1].id }
    let(:supplier_framework_3_id) { supplier_frameworks[2].id }

    before do
      supplier_frameworks[3].update(enabled: false)

      supplier_framework_1_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[0], lot_id: 'RM6240.1a')
      supplier_framework_2_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[1], lot_id: 'RM6240.1a')
      supplier_framework_3_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[2], lot_id: 'RM6240.1a')
      supplier_framework_4_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[3], lot_id: 'RM6240.1a')
      supplier_framework_5_lot_a = create(:supplier_framework_lot, supplier_framework: supplier_frameworks[4], lot_id: 'RM6240.1a', enabled: false)

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_1_lot_a, service_id: 'RM6240.1a.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6240.1a.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6240.1a.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_4_lot_a, service_id: 'RM6240.1a.1')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_5_lot_a, service_id: 'RM6240.1a.1')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_1_lot_a, service_id: 'RM6240.1a.2')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6240.1a.2')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_2_lot_a, service_id: 'RM6240.1a.3')
      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6240.1a.3')

      create(:supplier_framework_lot_service, supplier_framework_lot: supplier_framework_3_lot_a, service_id: 'RM6240.1a.4')

      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_1_lot_a, jurisdiction_id: 'GB')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_2_lot_a, jurisdiction_id: 'GB')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_2_lot_a, jurisdiction_id: 'AX')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_3_lot_a, jurisdiction_id: 'GB')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_3_lot_a, jurisdiction_id: 'AX')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_4_lot_a, jurisdiction_id: 'GB')
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_5_lot_a, jurisdiction_id: 'GB')
    end

    context 'when we pass a single service code and jurisdiction id' do
      let(:service_ids) { ['RM6240.1a.1'] }
      let(:jurisdiction_ids) { ['GB'] }

      it 'returns three suppliers' do
        expect(result).to contain_exactly(supplier_framework_1_id, supplier_framework_2_id, supplier_framework_3_id)
      end
    end

    context 'when we pass multiple service codes and a single jurisdiction id' do
      let(:service_ids) { ['RM6240.1a.1', 'RM6240.1a.2'] }
      let(:jurisdiction_ids) { ['GB'] }

      it 'returns the first and second suppliers' do
        expect(result).to contain_exactly(supplier_framework_1_id, supplier_framework_2_id)
      end
    end

    context 'when we pass multiple jurisdiction ids and single service ids' do
      let(:service_ids) { ['RM6240.1a.1'] }
      let(:jurisdiction_ids) { ['GB', 'AX'] }

      it 'returns the second and third suppliers' do
        expect(result).to contain_exactly(supplier_framework_2_id, supplier_framework_3_id)
      end
    end

    context 'when we pass multiple service codes and a multiple jurisdiction ids' do
      let(:service_ids) { ['RM6240.1a.3', 'RM6240.1a.4'] }
      let(:jurisdiction_ids) { ['GB', 'AX'] }

      it 'returns the third supplier' do
        expect(result).to contain_exactly(supplier_framework_3_id)
      end
    end

    context 'when we pass service codes neither supplier does' do
      let(:service_ids) { ['RM6240.2a.1'] }
      let(:jurisdiction_ids) { ['GB'] }

      it 'returns an emoty array' do
        expect(result).to be_empty
      end
    end

    context 'when we pass jurisdictions neither supplier does' do
      let(:service_ids) { ['RM6240.1a.1'] }
      let(:jurisdiction_ids) { ['DE'] }

      it 'returns an emoty array' do
        expect(result).to be_empty
      end
    end
  end
end
