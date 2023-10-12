require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::AssessedValueCalculator do
  subject(:assessed_value_calulator) { described_class.new(procurement.id) }

  let(:assessed_value) { assessed_value_calulator.assessed_value.round(2) }
  let(:lot_number) { assessed_value_calulator.lot_number }

  let(:user) { create(:user) }
  let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, user:, estimated_annual_cost:, service_codes:, **additional_params) }

  describe 'when the buyer input is known and any service is missing framework and benchmark rate' do
    context 'when CAFM Helpdesk and TUPE are not required' do
      let(:service_codes) { %w[C.1 D.3 G.1 I.1 K.2] }
      let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 34)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 130)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 1576000 }

        it 'returns £1,576,000.00 for the assessed value' do
          expect(assessed_value).to eq 1576000.0
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 1575000 }

        it 'returns £1,260,112.50 for the assessed value' do
          expect(assessed_value).to eq 1260112.5
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 848500 }

        it 'returns £1,017,945.83 for the assessed value' do
          expect(assessed_value).to eq 1017945.83
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 848000 }

        it 'returns £848,000.00 for the assessed value' do
          expect(assessed_value).to eq 848000.0
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and it is a London building' do
      let(:service_codes) { %w[C.1 D.3 G.1 I.1 K.2 M.1 N.1 O.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 34)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 130)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 2136000 }

        it 'returns £2,136,000.00 for the assessed value' do
          expect(assessed_value).to eq 2136000
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 2135000 }

        it 'returns £1,708,356.02 for the assessed value' do
          expect(assessed_value).to eq 1708356.02
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 1151000 }

        it 'returns £1,380,356.02 for the assessed value' do
          expect(assessed_value).to eq 1380356.02
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 1149000 }

        it 'returns £1,149,000.00 for the assessed value' do
          expect(assessed_value).to eq 1149000
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and it is a London building for lot 1b' do
      let(:service_codes) { %w[C.1 D.3 G.1 I.1 K.2 M.1 N.1 O.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 2, initial_call_off_period_months: 4 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 3400)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 13000)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 9150000 }

        it 'returns £21,350,000.00 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 21350000.0
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 9140000 }

        it 'returns £17,064,407.47 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 17064407.47
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 4925000 }

        it 'returns £13,786,074.13 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 13786074.13
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 4910000 }

        it 'returns £11,456,666.67 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 11456666.67
          expect(lot_number).to eq '1b'
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and there are two buildings for lot 1c' do
      let(:service_codes) { %w[C.1 D.3 G.1 I.1 K.2 M.1 N.1 O.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 7, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.where(code: 'C.1').find_each { |pbs| pbs.update(service_standard: 'A') }
        procurement.procurement_building_services.where(code: 'G.1').find_each { |pbs| pbs.update(service_standard: 'A', no_of_building_occupants: 3400) }
        procurement.procurement_building_services.where(code: 'I.1').find_each { |pbs| pbs.update(service_hours: 6240) }
        procurement.procurement_building_services.where(code: 'K.2').find_each { |pbs| pbs.update(tones_to_be_collected_and_removed: 13000) }
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 16750000 }

        it 'returns £117,250,000.00 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 117250000.0
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 16700000 }

        it 'returns £93,550,612.94 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 93550612.94
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 9000000 }

        it 'returns £75,583,946.27 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 75583946.27
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 8995000 }

        it 'returns £62,965,000.00 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 62965000.0
          expect(lot_number).to eq '1c'
        end
      end
    end
  end
end
