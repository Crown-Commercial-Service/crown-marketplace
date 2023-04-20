require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SummaryReport, type: :model do
  subject(:report) { described_class.new(procurement.id) }

  let(:procurement) do
    create(:facilities_management_rm3830_procurement_with_contact_details_with_buildings,
           initial_call_off_period_years:,
           initial_call_off_period_months:)
  end

  let(:supplier_id) { '24bde4cf-6ccc-4367-ba16-77deb593d3c3' }

  describe '.calculate_services_for_buildings' do
    context 'when years are 0 and months are 4' do
      let(:initial_call_off_period_years) { 0 }
      let(:initial_call_off_period_months) { 4 }

      it 'returns 0.333 for contract_length_years' do
        expect(report.instance_variable_get(:@contract_length_years).round(3)).to eq 0.333
      end

      context 'and without supplier id' do
        before { report.calculate_services_for_buildings }

        it 'returns £4,276.06 for framework' do
          expect(report.sum_uom.round(2)).to eq 4276.06
        end

        it 'returns £2,427.99 for benchmark' do
          expect(report.sum_benchmark.round(2)).to eq 2427.99
        end
      end

      context 'and with supplier id' do
        before { report.calculate_services_for_buildings(supplier_id) }

        it 'returns £4,490.46 for direct award' do
          expect(report.sum_uom.round(2)).to eq 4490.46
        end
      end
    end

    context 'when years are 2 and months 0' do
      let(:initial_call_off_period_years) { 2 }
      let(:initial_call_off_period_months) { 0 }

      it 'returns 2.0 for contract_length_years' do
        expect(report.instance_variable_get(:@contract_length_years).round(3)).to eq 2.0
      end

      context 'and without supplier id' do
        before { report.calculate_services_for_buildings }

        it 'returns £25,656.39 for framework' do
          expect(report.sum_uom.round(2)).to eq 25656.39
        end

        it 'returns £14,159.65 for benchmark' do
          expect(report.sum_benchmark.round(2)).to eq 14159.65
        end
      end

      context 'and with supplier id' do
        before { report.calculate_services_for_buildings(supplier_id) }

        it 'returns £26,327.38 for direct award' do
          expect(report.sum_uom.round(2)).to eq 26327.38
        end
      end
    end

    context 'when years are 3 and months 8' do
      let(:initial_call_off_period_years) { 3 }
      let(:initial_call_off_period_months) { 7 }

      it 'returns 3.583 for contract_length_years' do
        expect(report.instance_variable_get(:@contract_length_years).round(3)).to eq 3.583
      end

      context 'and without supplier id' do
        before { report.calculate_services_for_buildings }

        it 'returns £45,967.69 for framework' do
          expect(report.sum_uom.round(2)).to eq 45967.69
        end

        it 'returns £25,046.16 for benchmark' do
          expect(report.sum_benchmark.round(2)).to eq 25046.16
        end
      end

      context 'and with supplier id' do
        before { report.calculate_services_for_buildings(supplier_id) }

        it 'returns £46,682.72 for direct award' do
          expect(report.sum_uom.round(2)).to eq 46682.72
        end
      end
    end
  end
end
