require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:procurement_with_buildings) { create(:facilities_management_rm3830_procurement_for_further_competition_with_gia) }

  let(:supplier_ids) { FacilitiesManagement::RM3830::SupplierDetail.where(supplier_name: supplier_names).pluck(:supplier_id) }

  include_context 'with list of suppliers'

  context 'when testing FC report methods' do
    it 'create a further competition excel,very worksheets are there' do
      first_building = procurement_with_buildings.active_procurement_buildings.first
      create(:facilities_management_rm3830_procurement_building_service_with_service_hours, procurement_building: first_building)

      report = described_class.new(procurement_with_buildings.id)

      supplier_ids.each do |supplier_id|
        report.calculate_services_for_buildings(supplier_id, :fc)
        expect(report.direct_award_value).to be > 0
      end
    end
  end

  describe 'assessed_value for FC sub-lots' do
    let(:code) { nil }
    let(:code1) { nil }
    let(:code2) { nil }
    let(:lift_data) { [] }
    let(:estimated_annual_cost) { 7000000 }
    let(:estimated_cost_known) { true }
    let(:service_standard) { 'A' }
    let(:procurement_building_service) do
      create(:facilities_management_rm3830_procurement_building_service,
             code: code,
             service_standard: service_standard,
             procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                          building_id: create(:facilities_management_building_london).id,
                                          procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings,
                                                              estimated_annual_cost:,
                                                              estimated_cost_known:)))
    end
    let(:procurement_building_service_1) do
      create(:facilities_management_rm3830_procurement_building_service,
             code: code1,
             procurement_building: procurement_building_service.procurement_building)
    end
    let(:procurement_building_service_2) do
      create(:facilities_management_rm3830_procurement_building_service,
             code: code2,
             procurement_building: procurement_building_service_1.procurement_building)
    end

    let(:report) { described_class.new(procurement_building_service_2.procurement_building.procurement.id) }

    before do
      lift_data.each do |number_of_floors|
        procurement_building_service.lifts.create(number_of_floors:)
      end

      report.calculate_services_for_buildings
    end

    context 'when framework price for at least one service is missing' do
      let(:code) { 'C.5' }
      let(:lift_data) { %w[999 999 999 999] }
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
        let(:estimated_annual_cost) { 1844700 }

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
      let(:lift_data) { %w[999 999 999 999] }
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
