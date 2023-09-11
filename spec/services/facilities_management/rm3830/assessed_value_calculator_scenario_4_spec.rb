require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::AssessedValueCalculator do
  subject(:assessed_value_calulator) { described_class.new(procurement.id) }

  let(:assessed_value) { assessed_value_calulator.assessed_value.round(2) }
  let(:lot_number) { assessed_value_calulator.lot_number }

  let(:user) { create(:user) }
  let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, user: user, estimated_cost_known: false, service_codes: service_codes, **additional_params) }

  describe 'when some, but not all, services are missing framework rate and there is no buyer input' do
    context 'when CAFM Helpdesk and TUPE are not required' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2] }
      let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 0, initial_call_off_period_months: 6 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: no_of_building_occupants)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed:)
      end

      context 'and the variance is just below 30%' do
        let(:no_of_building_occupants) { 19000 }
        let(:tones_to_be_collected_and_removed) { 2300 }

        it 'returns £1,012,350.44 for the assessed value' do
          expect(assessed_value).to eq 1012350.44
        end
      end

      context 'and the variance is just above 30%' do
        let(:no_of_building_occupants) { 19200 }
        let(:tones_to_be_collected_and_removed) { 2310 }

        it 'returns £1,169,206.42 for the assessed value' do
          expect(assessed_value).to eq 1169206.42
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and it is a London building' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2 M.1 N.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 0, initial_call_off_period_months: 6 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: no_of_building_occupants)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed:)
      end

      context 'and the variance is just below 30%' do
        let(:no_of_building_occupants) { 750 }
        let(:tones_to_be_collected_and_removed) { 4600 }

        it 'returns £1,612,276.21 for the assessed value' do
          expect(assessed_value).to eq 1612276.21
        end
      end

      context 'and the variance is just above 30%' do
        let(:no_of_building_occupants) { 750 }
        let(:tones_to_be_collected_and_removed) { 4550 }

        it 'returns £1,392,746.47 for the assessed value' do
          expect(assessed_value).to eq 1392746.47
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and it is a London building for lot 1b' do
      let(:service_codes) { %w[C.1 C.20 G.1 I.1 K.2 M.1 N.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 3, initial_call_off_period_months: 8 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        procurement.procurement_building_services.find_by(code: 'G.1').update(service_standard: 'A', no_of_building_occupants: no_of_building_occupants)
        procurement.procurement_building_services.find_by(code: 'I.1').update(service_hours: 6240)
        procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed:)
      end

      context 'and the variance is just below 30%' do
        let(:no_of_building_occupants) { 1300 }
        let(:tones_to_be_collected_and_removed) { 5950 }

        it 'returns £13,529,127.13 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 13529127.13
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just above 30%' do
        let(:no_of_building_occupants) { 1250 }
        let(:tones_to_be_collected_and_removed) { 5900 }

        it 'returns £11,692,095.07 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 11692095.07
          expect(lot_number).to eq '1b'
        end
      end
    end

    context 'when CAFM Helpdesk and TUPE are required and there are two buildings for lot 1b' do
      let(:service_codes) { %w[C.1 C.2 C.3 C.20 G.1 I.1 K.2 K.3 M.1 N.1] }
      let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 7, initial_call_off_period_months: 0 } }

      before do
        create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
        create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
        procurement.procurement_building_services.where(code: %w[C.1 C.2 C.3]).find_each { |pbs| pbs.update(service_standard: 'A') }
        procurement.procurement_building_services.where(code: 'G.1').find_each { |pbs| pbs.update(service_standard: 'A', no_of_building_occupants: no_of_building_occupants) }
        procurement.procurement_building_services.where(code: 'I.1').find_each { |pbs| pbs.update(service_hours: 6240) }
        procurement.procurement_building_services.where(code: %w[K.2 K.3]).find_each { |pbs| pbs.update(tones_to_be_collected_and_removed:) }
      end

      context 'and the variance is just below 30%' do
        let(:no_of_building_occupants) { 1080 }
        let(:tones_to_be_collected_and_removed) { 2700 }

        it 'returns £45,638,452.13 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 45638452.13
          expect(lot_number).to eq '1b'
        end
      end

      context 'and the variance is just above 30%' do
        let(:no_of_building_occupants) { 1075 }
        let(:tones_to_be_collected_and_removed) { 2680 }

        it 'returns £39,532,439.34 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 39532439.34
          expect(lot_number).to eq '1b'
        end
      end
    end
  end
end
