require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::AssessedValueCalculator do
  subject(:assessed_value_calulator) { described_class.new(procurement.id) }

  let(:assessed_value) { assessed_value_calulator.assessed_value.round(2) }
  let(:lot_number) { assessed_value_calulator.lot_number }

  let(:user) { create(:user) }
  let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, user:, estimated_annual_cost:, service_codes:, **additional_params) }

  describe 'when the buyer input is known and any service is missing framework rate' do
    context 'when CAFM Helpdesk and TUPE are not required' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2] }
      let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 34)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 130)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 3330000 }

        it 'returns £2,058,170.52 for the assessed value' do
          expect(assessed_value).to eq 2058170.52
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 3310000 }

        it 'returns £1,844,261.98 for the assessed value' do
          expect(assessed_value).to eq 1844261.98
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 1430000 }

        it 'returns £1,217,595.31 for the assessed value' do
          expect(assessed_value).to eq 1217595.31
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 1410000 }

        it 'returns £1,098,170.52 for the assessed value' do
          expect(assessed_value).to eq 1098170.52
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and it is a London building' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2 M.1 N.1 O.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 34)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 130)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 1935410 }

        it 'returns £1,498,923.18 for the assessed value' do
          expect(assessed_value).to eq 1498923.18
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 1940000 }

        it 'returns £1,651,214.29 for the assessed value' do
          expect(assessed_value).to eq 1651214.29
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 4520000 }

        it 'returns £2,791,218.18 for the assessed value' do
          expect(assessed_value).to eq 2791218.18
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 4510000 }

        it 'returns £2,507,880.96 for the assessed value' do
          expect(assessed_value).to eq 2507880.96
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are not required for lot 1b' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2 H.4] }
      let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 4, initial_call_off_period_months: 8 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 18000)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 8736)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 1300)
        procurement.procurement_building_services.find_by(code: 'H.4').update(service_hours: 8736)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 5510000 }

        it 'returns £17,235,826.24 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 17235826.24
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 5500000 }

        it 'returns £15,491,451.91 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 15491451.91
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 2100000 }

        it 'returns £10,202,563.02 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 10202563.02
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 2090000 }

        it 'returns £9,255,826.24 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 9255826.24
          expect(lot_number).to eq '1b'
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are not required for lot 1c' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2 H.4] }
      let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 6, initial_call_off_period_months: 9 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 88000)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 8736)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 26000)
        procurement.procurement_building_services.find_by(code: 'H.4').update(service_hours: 8736)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 22500000 }

        it 'returns £111,992,091.70 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 111992091.7
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 22350000 }

        it 'returns £100,356,791.04 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 100356791.04
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 7100000 }

        it 'returns £60,017,091.70 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 60017091.7
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 7130000 }

        it 'returns £66,111,791.04 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 66111791.04
          expect(lot_number).to eq '1c'
        end
      end
    end

    context 'when buyer input is known, no TUPE and CAFM Helpdesk are required and it is a London building' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2 H.4 M.1 N.1 O.1] }
      let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 7, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: 88000)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 8736)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 13000)
        procurement.procurement_building_services.find_by(code: 'H.4').update(service_hours: 8736)
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 19500000 }

        it 'returns £99,477,009.73 for the assessed value' do
          expect(assessed_value).to eq 99477009.73
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 19450000 }

        it 'returns £89,395,894.52 for the assessed value' do
          expect(assessed_value).to eq 89395894.52
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 6390000 }

        it 'returns £58,922,561.19 for the assessed value' do
          expect(assessed_value).to eq 58922561.19
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 6350000 }

        it 'returns £53,452,009.73 for the assessed value' do
          expect(assessed_value).to eq 53452009.73
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and there are two buildings for lot 1c' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2 H.4 M.1 N.1 O.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 5, initial_call_off_period_months: 7 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.where(code: 'C.1').find_each { |pbs| pbs.update(service_standard: 'A') }
        procurement.procurement_building_services.where(code: 'G.1').find_each { |pbs| pbs.update(service_standard: 'A', no_of_building_occupants: 88000) }
        procurement.procurement_building_services.where(code: 'I.1').find_each { |pbs| pbs.update(service_hours: 8736) }
        procurement.procurement_building_services.where(code: 'K.2').find_each { |pbs| pbs.update(tones_to_be_collected_and_removed: 13000) }
        procurement.procurement_building_services.where(code: 'H.4').find_each { |pbs| pbs.update(service_hours: 8736) }
      end

      context 'and the variance is just below -30%' do
        let(:estimated_annual_cost) { 39300000 }

        it 'returns £159,991,912.32 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 159991912.32
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just above -30%' do
        let(:estimated_annual_cost) { 39230000 }

        it 'returns £143,829,391.54 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 143829391.54
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just below 30%' do
        let(:estimated_annual_cost) { 12825000 }

        it 'returns £94,686,752.65 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 94686752.65
          expect(lot_number).to eq '1c'
        end
      end

      context 'and the variance is just above 30%' do
        let(:estimated_annual_cost) { 12800000 }

        it 'returns £86,012,745.65 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 86012745.65
          expect(lot_number).to eq '1c'
        end
      end
    end
  end
end
