require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:procurement_with_buildings) { create(:facilities_management_procurement_for_further_competition_with_gia) }

  let(:spreadsheet_builder) { FacilitiesManagement::FurtherCompetitionSpreadsheetCreator.new(procurement_with_buildings.id) }

  context 'when testing FC report methods' do
    it 'create a further competition excel,very worksheets are there' do
      first_building = procurement_with_buildings.active_procurement_buildings.first
      create(:facilities_management_procurement_building_service_with_service_hours, procurement_building: first_building)

      report = described_class.new(procurement_with_buildings.id)

      supplier_names = CCS::FM::RateCard.latest.data[:Prices].keys
      supplier_names.each do |supplier_name|
        report.calculate_services_for_buildings(supplier_name, true, :fc)
        expect(report.direct_award_value).to be > 0
      end

      expect(report.assessed_value).to eq 838.1929279363201
    end
  end

  describe 'validate worksheets' do
    let(:wb) do
      first_building = procurement_with_buildings.active_procurement_buildings.first
      create(:facilities_management_procurement_building_service_with_service_hours, procurement_building: first_building)
      report = described_class.new(procurement_with_buildings.id)

      supplier_names = CCS::FM::RateCard.latest.data[:Prices].keys
      supplier_names.each do |supplier_name|
        report.calculate_services_for_buildings(supplier_name, true, :fc)
      end
      spreadsheet = spreadsheet_builder.build
      IO.write('/tmp/further_competition_procurement_summary.xlsx', spreadsheet.to_stream.read)
      Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'Verify Service Marix headers' do
      expect(wb.sheet('Service Matrix').row(1)).to eq ['Service Reference', 'Service Name', 'Building 1']
      expect(wb.sheet('Service Matrix').row(2)).to eq [nil, nil, 'asa']
      expect(wb.sheet('Service Matrix').row(3)).to eq ['C.1', 'Mechanical and electrical engineering maintenance - Standard A', 'Yes']
      expect(wb.sheet('Service Matrix').row(4)).to eq ['H.4', 'Handyman services', 'Yes']
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'Verify Volume headers' do
      expect(wb.sheet('Volume').row(1)).to eq ['Service Reference', 'Service Name', 'Metric per annum', 'Building 1']
      expect(wb.sheet('Volume').row(2)).to eq [nil, nil, nil, 'asa']
      expect(wb.sheet('Volume').row(3)).to eq ['H.4', 'Handyman services', 'Number of hours required', 208.0]
    end

    it 'Verify Service Periods headers' do
      expect(wb.sheet('Service Periods').row(1)).to eq ['Service Reference', 'Service Name', 'Specific Service Periods', 'Building 1']
      expect(wb.sheet('Service Periods').row(2)).to eq [nil, nil, nil, 'asa']
      expect(wb.sheet('Service Periods').row(3)).to eq ['H.4', 'Handyman services', 'Monday', '9:00am to 1:00pm']
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'Verify Shortlist headers' do
      expect(wb.sheet('Shortlist').row(1)).to eq ['Reference number & date/time production of this document', ' - ']
      expect(wb.sheet('Shortlist').row(2)).to eq [nil, nil]
      expect(wb.sheet('Shortlist').row(3)).to eq ['Cost and sub-lot recommendation', nil]
      expect(wb.sheet('Shortlist').row(4)).to eq ['Estimated cost', '£11,541.72 ']
      expect(wb.sheet('Shortlist').row(5)).to eq ['Sub-lot recommendation', 'Sub-lot 1a']
      expect(wb.sheet('Shortlist').row(6)).to eq ['Sub-lot value range', 'Up to £7m']
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'assessed_value for FC sub-lots' do
    let(:code) { nil }
    let(:code1) { nil }
    let(:code2) { nil }
    let(:lift_data) { nil }
    let(:estimated_annual_cost) { 7000000 }
    let(:estimated_cost_known) { true }
    let(:service_standard) { 'A' }
    let(:procurement_building_service) do
      create(:facilities_management_procurement_building_service,
             code: code,
             service_standard: service_standard,
             lift_data: lift_data,
             procurement_building: create(:facilities_management_procurement_building_no_services,
                                          building_id: create(:facilities_management_building_london).id,
                                          procurement: create(:facilities_management_procurement_no_procurement_buildings,
                                                              estimated_annual_cost: estimated_annual_cost,
                                                              estimated_cost_known: estimated_cost_known)))
    end
    let(:procurement_building_service_1) do
      create(:facilities_management_procurement_building_service,
             code: code1,
             procurement_building: procurement_building_service.procurement_building)
    end
    let(:procurement_building_service_2) do
      create(:facilities_management_procurement_building_service,
             code: code2,
             procurement_building: procurement_building_service_1.procurement_building)
    end

    let(:report) { described_class.new(procurement_building_service_2.procurement_building.procurement.id) }

    before do
      report.calculate_services_for_buildings
    end

    context 'when framework price for at least one service is missing' do
      let(:code) { 'C.5' }
      let(:lift_data) { %w[1000 1000 1000 1000] }
      let(:code1) { 'G.9' } # no fw price
      let(:code2) { 'C.7' } # no fw price

      context 'when variance between the Customer & BM prices and the available FW prices is >|30%|' do
        let(:estimated_annual_cost) { 1 }
        let(:service_standard) { 'B' } # C.5 no fw price (standard B)

        it 'uses BM and Customer prices only' do
          expect(report.assessed_value.round(2)).to eq(((report.buyer_input + report.sum_benchmark) / 2.0).round(2))
        end
      end

      context 'when variance between the Customer & BM prices and the available FW prices is >|-30%| and <|30%|' do
        let(:estimated_annual_cost) { 1850843 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark + report.buyer_input) / 3.0).round(2))
        end
      end

      context 'when variance between the Customer & BM prices and the available FW prices is and <|-30%|' do
        let(:estimated_annual_cost) { 125084300 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.buyer_input + report.sum_benchmark) / 2.0).round(2))
        end
      end

      context 'when no Customer price' do
        let(:estimated_annual_cost) { nil }
        let(:estimated_cost_known) { false }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark) / 2.0).round(2))
        end
      end
    end

    context 'when at least one service missing framework price and at least one service is missing benchmark price' do
      let(:code) { 'C.5' }
      let(:lift_data) { %w[1000 1000 1000 1000] }
      let(:code1) { 'G.9' } # no fw price
      let(:code2) { 'G.8' } # no fw & no bm price

      context 'when variance between FM & BM and Customer input is >|30%|' do
        let(:lift_data) { %w[10] }
        let(:estimated_annual_cost) { 1 }

        it 'uses Customer price only' do
          expect(report.assessed_value.round(2)).to eq(report.buyer_input.round(2))
        end
      end

      context 'when variance between FM & BM and Customer input is >|-30%| and <|30%|' do
        let(:estimated_annual_cost) { 1227921 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark + report.buyer_input) / 3.0).round(2))
        end
      end

      context 'when variance between FM & BM and Customer input is <|-30%|' do
        let(:estimated_annual_cost) { 2000 }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(report.buyer_input.round(2))
        end
      end

      context 'when no Customer price' do
        let(:estimated_annual_cost) { nil }
        let(:estimated_cost_known) { false }

        it 'uses FW, BM and Customer prices' do
          expect(report.assessed_value.round(2)).to eq(((report.sum_uom + report.sum_benchmark) / 2.0).round(2))
        end
      end
    end
  end
end
