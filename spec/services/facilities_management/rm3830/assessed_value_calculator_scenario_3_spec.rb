require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::AssessedValueCalculator do
  subject(:assessed_value_calulator) { described_class.new(procurement.id) }

  let(:assessed_value) { assessed_value_calulator.assessed_value.round(2) }
  let(:lot_number) { assessed_value_calulator.lot_number }

  let(:user) { create(:user) }
  let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, user: user, estimated_cost_known: false, service_codes: service_codes, **additional_params) }

  describe 'when some, but not all, services are missing framework and beanchmaek rate and there is no buyer input' do
    context 'and the price is in the lot 1a range' do
      context 'when CAFM Helpdesk and TUPE are not required' do
        let(:service_codes) { %w[C.1 D.3] }
        let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 6 } }

        before do
          create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
          procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        end

        it 'returns £432,180.01 for the assessed value and 1a for the lot number' do
          expect(assessed_value).to eq 432180.01
          expect(lot_number).to eq '1a'
        end
      end

      context 'when CAFM Helpdesk and TUPE are required and it is a London building' do
        let(:service_codes) { %w[C.1 D.3 M.1 N.1] }
        let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 6 } }

        before do
          create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
          procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
        end

        it 'returns £586,287.26 for the assessed value and 1a for the lot number' do
          expect(assessed_value).to eq 586287.26
          expect(lot_number).to eq '1a'
        end
      end
    end

    context 'and the price is in the lot 1b range' do
      context 'when CAFM Helpdesk and TUPE are not required' do
        let(:service_codes) { %w[C.1 C.2 D.3 G.3 C.3 K.2 K.3] }
        let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 6 } }

        before do
          create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
          procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'C.2').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'G.3').update(service_standard: 'A', no_of_building_occupants: 10000)
          procurement.procurement_building_services.find_by(code: 'C.3').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 30000)
          procurement.procurement_building_services.find_by(code: 'K.3').update(tones_to_be_collected_and_removed: 30000)
        end

        it 'returns £25,253,162.26 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 25253162.26
          expect(lot_number).to eq '1b'
        end
      end

      context 'when CAFM Helpdesk and TUPE are required and it is a London building' do
        let(:service_codes) { %w[C.1 C.2 D.3 G.3 C.3 K.2 K.3 M.1 N.1] }
        let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 1, initial_call_off_period_months: 6 } }

        before do
          create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
          procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'C.2').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'G.3').update(service_standard: 'A', no_of_building_occupants: 10000)
          procurement.procurement_building_services.find_by(code: 'C.3').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 30000)
          procurement.procurement_building_services.find_by(code: 'K.3').update(tones_to_be_collected_and_removed: 30000)
        end

        it 'returns £34,240,089.26 for the assessed value and 1b for the lot number' do
          expect(assessed_value).to eq 34240089.26
          expect(lot_number).to eq '1b'
        end
      end
    end

    context 'and the price is in the lot 1c range' do
      context 'when CAFM Helpdesk and TUPE are not required' do
        let(:service_codes) { %w[C.1 C.2 D.3 G.3 C.3 K.2 K.3] }
        let(:additional_params) { { tupe: false, mobilisation_period_required: false, extensions_required: false, initial_call_off_period_years: 3, initial_call_off_period_months: 1 } }

        before do
          create(:facilities_management_rm3830_procurement_building_av_normal_building, procurement:, service_codes:)
          procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'C.2').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'G.3').update(service_standard: 'A', no_of_building_occupants: 10000)
          procurement.procurement_building_services.find_by(code: 'C.3').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 30000)
          procurement.procurement_building_services.find_by(code: 'K.3').update(tones_to_be_collected_and_removed: 30000)
        end

        it 'returns £51,354,022.76 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 51354022.76
          expect(lot_number).to eq '1c'
        end
      end

      context 'when CAFM Helpdesk and TUPE are required and it is a London building' do
        let(:service_codes) { %w[C.1 C.2 D.3 G.3 C.3 K.2 K.3 M.1 N.1] }
        let(:additional_params) { { tupe: true, mobilisation_period_required: true, mobilisation_period: 4, extensions_required: false, initial_call_off_period_years: 3, initial_call_off_period_months: 1 } }

        before do
          create(:facilities_management_rm3830_procurement_building_av_london_building, procurement:, service_codes:)
          procurement.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'C.2').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'G.3').update(service_standard: 'A', no_of_building_occupants: 10000)
          procurement.procurement_building_services.find_by(code: 'C.3').update(service_standard: 'A')
          procurement.procurement_building_services.find_by(code: 'K.2').update(tones_to_be_collected_and_removed: 30000)
          procurement.procurement_building_services.find_by(code: 'K.3').update(tones_to_be_collected_and_removed: 30000)
        end

        it 'returns £69,693,416.36 for the assessed value and 1c for the lot number' do
          expect(assessed_value).to eq 69693416.36
          expect(lot_number).to eq '1c'
        end
      end
    end
  end
end
