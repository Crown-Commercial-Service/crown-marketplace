require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::AssessedValueCalculator do
  subject(:assessed_value_calulator) { described_class.new(procurement.id) }

  let(:assessed_value) { assessed_value_calulator.assessed_value.round(2) }
  let(:lot_number) { assessed_value_calulator.lot_number }

  let(:user) { create(:user) }
  let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, user:, service_codes:, **additional_params) }

  describe 'when all services have framework and beanchmaek rates' do
    context 'when CAFM Helpdesk and TUPE are not required' do
      let(:service_codes) { %w[C.1 G.1 I.1 K.2] }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 34)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 130)
      end

      context 'and there is buyer input' do
        let(:additional_params) { { estimated_annual_cost: 1000000, tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 2, initial_call_off_period_months: 3 } }

        it 'returns £2,384,449.91 for the assessed value' do
          expect(assessed_value).to eq 2384449.91
        end
      end

      context 'and there is no buyer input' do
        let(:additional_params) { { estimated_cost_known: false, tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 2, initial_call_off_period_months: 3 } }

        it 'returns £2,451,674.87 for the assessed value' do
          expect(assessed_value).to eq 2451674.87
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and it is a London building' do
      let(:service_codes) { %w[C.1 G.1 I.1 K.2 M.1 N.1] }

      before do
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 34)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 130)
      end

      context 'and there is buyer input' do
        let(:additional_params) { { estimated_annual_cost: 1200000, tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 2, initial_call_off_period_months: 3 } }

        it 'returns £3,118,288.40 for the assessed value' do
          expect(assessed_value).to eq 3118288.40
        end
      end

      context 'and there is no buyer input' do
        let(:additional_params) { { estimated_cost_known: false, tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 2, initial_call_off_period_months: 3 } }

        it 'returns £3,327,432.60 for the assessed value' do
          expect(assessed_value).to eq 3327432.60
        end
      end
    end

    context 'when buyer input is provided CAFM Helpdesk and TUPE are required and there are two buildings' do
      let(:service_codes) { %w[C.2 C.5 E.4 G.1 M.1 N.1 O.1] }
      let(:additional_params) { { estimated_annual_cost: estimated_annual_cost, tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: initial_call_off_period_years, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.where(code: %w[C.2 C.5 G.1]).each { |pbs| pbs.update(service_standard: 'A') }
        procurement.procurement_building_services.where(code: 'G.1').each { |pbs| pbs.update(no_of_building_occupants: volume) }
        procurement.procurement_building_services.where(code: 'E.4').each { |pbs| pbs.update(no_of_appliances_for_testing: volume) }
        procurement.procurement_building_services.where(code: 'C.5').each { |pbs| no_of_lifts.times { pbs.lifts.create(number_of_floors:) } }
      end

      context 'and the lot is 1a' do
        let(:estimated_annual_cost) { 2300000 }
        let(:initial_call_off_period_years) { 2 }
        let(:volume) { 130 }
        let(:no_of_lifts) { 1 }
        let(:number_of_floors) { 300 }

        it 'returns £4,648,235.71 for the assessed value and 1a for the lot number' do
          expect(assessed_value).to eq 4648235.71
          expect(lot_number).to eq '1a'
        end
      end

      context 'and the lot is 1b' do
        let(:estimated_annual_cost) { 2300000 }
        let(:initial_call_off_period_years) { 2 }
        let(:volume) { 1300 }
        let(:no_of_lifts) { 5 }
        let(:number_of_floors) { 600 }

        it 'returns £7,075,207.13 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 7075207.13
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the lot is 1c' do
        let(:estimated_annual_cost) { 50000000 }
        let(:initial_call_off_period_years) { 3 }
        let(:volume) { 1300 }
        let(:no_of_lifts) { 5 }
        let(:number_of_floors) { 600 }

        it 'returns £58,278,548.40 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 58278548.4
          expect(lot_number).to eq '1c'
        end
      end
    end
  end
end
