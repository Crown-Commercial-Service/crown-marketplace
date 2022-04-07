require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SummaryReport, type: :model do
  subject(:report) { described_class.new(procurement.id) }

  let(:procurement) do
    create(:facilities_management_rm3830_procurement_with_extension_periods,
           initial_call_off_period_years: 7,
           lot_number_selected_by_customer: lot_number_selected_by_customer)
  end

  let(:lot_number_selected_by_customer) { false }

  describe '#calculate_services_for_buildings' do
    let(:building_id) { procurement.procurement_buildings.first.building.id }
    let(:service_code) { 'C.1' }

    before { report.calculate_services_for_buildings(supplier_id) }

    context 'when supplier_id provided' do
      let(:supplier_id) { 'ec27d911-6800-4a7b-bf52-19278431d012' }

      context 'when remove CAFM help is true' do
        let(:remove_cafm_help) { true }

        it 'results key matches building ID' do
          expect(report.results.keys.first).to eq(building_id)
        end

        it 'results has the service code' do
          expect(report.results[building_id].keys.first).to eq(service_code)
        end

        # rubocop:disable RSpec/ExampleLength
        it 'results has the correct values' do
          expected = {
            subtotal1: 3752,
            year_1_total_charges: 4810,
            cafm: 0,
            helpdesk: 0,
            london_variance: 0,
            tupe_risk_premium: 0,
            management_overhead: 535,
            corporate_overhead: 207,
            profit: 129,
            mobilisation: 188,
            subsequent_yearly_charge: 4581
          }

          expected.each do |key, rounded_value|
            expect(report.results[building_id][service_code][key].round).to eq(rounded_value)
          end
        end
        # rubocop:enable RSpec/ExampleLength

        it 'sum uom is correct' do
          expect(report.sum_uom.round).to eq(32294)
        end

        it 'sum benchmark is correct' do
          expect(report.sum_benchmark.round).to eq(0)
        end
      end

      # TODO: context 'when remove CAFM help is false'
    end

    context 'when supplier_id not provided' do
      let(:supplier_id) { nil }
      let(:remove_cafm_help) { true }

      it 'results are empty' do
        expect(report.results).to be_empty
      end

      it 'sum uom is correct' do
        expect(report.sum_uom.round).to eq(41015)
      end

      it 'sum benchmark is correct' do
        expect(report.sum_benchmark.round).to eq(22189)
      end
    end
  end

  describe '#values_to_average' do
    subject(:values_to_average) { report.values_to_average }

    let(:supplier_id) { 'ec27d911-6800-4a7b-bf52-19278431d012' }

    before { report.calculate_services_for_buildings(supplier_id) }

    it 'contains correct values' do
      expect(values_to_average.map(&:round)).to eq([32294, 0])
    end

    # TODO: contexts:
    #   any_services_missing_framework_price?
    #   any_services_missing_benchmark_price?
    #   varience_over_30_percent?
  end

  describe '#selected_suppliers' do
    subject(:selected_suppliers) { report.selected_suppliers(lot) }

    context 'when lot 1a' do
      let(:lot) { '1a' }

      it 'returns expected number of suppliers' do
        expect(selected_suppliers.first.class).to eq(FacilitiesManagement::RM3830::SupplierDetail)
        expect(selected_suppliers.size).to eq(15)
      end
    end

    context 'when lot 1b' do
      let(:lot) { '1b' }

      it 'returns expected number of suppliers' do
        expect(selected_suppliers.first.class).to eq(FacilitiesManagement::RM3830::SupplierDetail)
        expect(selected_suppliers.size).to eq(27)
      end
    end

    context 'when lot 1c' do
      let(:lot) { '1c' }

      it 'returns expected number of suppliers' do
        expect(selected_suppliers.first.class).to eq(FacilitiesManagement::RM3830::SupplierDetail)
        expect(selected_suppliers.size).to eq(20)
      end
    end
  end

  describe '#current_lot' do
    subject(:current_lot) { report.current_lot }

    context 'when lot number selected by customer' do
      let(:lot_number_selected_by_customer) { true }

      it 'returns procurement lot number' do
        expect(current_lot).to eq(procurement.lot_number)
      end
    end

    context 'when lot number not selected by customer' do
      before { report.instance_variable_set(:@assessed_value, assessed_value) }

      context 'when assessed value under 7m' do
        let(:assessed_value) { 6_000_000 }

        it 'returns 1a' do
          expect(current_lot).to eq('1a')
        end
      end

      context 'when assessed between 7m - 50m' do
        let(:assessed_value) { 8_000_000 }

        it 'returns 1b' do
          expect(current_lot).to eq('1b')
        end
      end

      context 'when assessed over 50m' do
        let(:assessed_value) { 51_000_000 }

        it 'returns 1c' do
          expect(current_lot).to eq('1c')
        end
      end
    end
  end
end
