require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  describe 'summary report initialising with procurement' do
    context 'when one building and one service' do
      let(:region_codes) { %w[UKI3 UKI4 UKI5 UKI6 UKI7] } # remove this once the logic to get the regions from the building is implemented
      let(:code) { nil }
      let(:lift_data) { nil }
      let(:no_of_appliances_for_testing) { nil }
      let(:no_of_building_occupants) { nil }
      let(:size_of_external_area) { nil }
      let(:no_of_consoles_to_be_serviced) { nil }
      let(:tones_to_be_collected_and_removed) { nil }
      let(:no_of_units_to_be_serviced) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               lift_data: lift_data,
               no_of_appliances_for_testing: no_of_appliances_for_testing,
               no_of_building_occupants: no_of_building_occupants,
               size_of_external_area: size_of_external_area,
               no_of_consoles_to_be_serviced: no_of_consoles_to_be_serviced,
               tones_to_be_collected_and_removed: tones_to_be_collected_and_removed,
               no_of_units_to_be_serviced: no_of_units_to_be_serviced,
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings,
                                                                region_codes: region_codes)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 4730.44
        end
      end

      context 'when service is C.2' do
        let(:code) { 'C.2' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 3189.34
        end
      end

      context 'when service is C.3' do
        let(:code) { 'C.3' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 258.93
        end
      end

      context 'when service is C.4' do
        let(:code) { 'C.4' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 1248.48
        end
      end

      context 'when service is C.6' do
        let(:code) { 'C.6' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 651.02
        end
      end

      context 'when service is C.7' do
        let(:code) { 'C.7' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 2719.17
        end
      end

      context 'when service is C.11' do
        let(:code) { 'C.11' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 609.22
        end
      end

      context 'when service is C.12' do
        let(:code) { 'C.12' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 716.92
        end
      end

      context 'when service is C.13' do
        let(:code) { 'C.13' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 363.09
        end
      end

      context 'when service is C.5' do
        let(:code) { 'C.5' }
        let(:lift_data) { %w[5 5 2 2] }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 3731.71
        end
      end

      context 'when service is C.14' do
        let(:code) { 'C.14' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 251.59
        end
      end

      context 'when service is C.8' do
        let(:code) { 'C.8' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 4995.73
        end
      end

      context 'when service is C.9' do
        let(:code) { 'C.9' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 1365.26
        end
      end

      context 'when service is C.10' do
        let(:code) { 'C.10' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 218.33
        end
      end

      context 'when service is C.15' do
        let(:code) { 'C.15' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 85.95
        end
      end

      context 'when service is C.16' do
        let(:code) { 'C.16' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 39.79
        end
      end

      context 'when service is C.17' do
        let(:code) { 'C.17' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 35.23
        end
      end

      context 'when service is C.18' do
        let(:code) { 'C.18' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 92.72
        end
      end

      context 'when service is C.19' do
        let(:code) { 'C.19' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is C.20' do
        let(:code) { 'C.20' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 142.79
        end
      end

      context 'when service is C.21' do
        let(:code) { 'C.21' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is C.22' do
        let(:code) { 'C.22' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is D.1' do
        let(:code) { 'D.1' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 2391.78
        end
      end

      context 'when service is D.2' do
        let(:code) { 'D.2' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 506.85
        end
      end

      context 'when service is D.3' do
        let(:code) { 'D.3' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0
        end
      end

      context 'when service is D.4' do
        let(:code) { 'D.4' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 83.68
        end
      end

      context 'when service is D.5' do
        let(:code) { 'D.5' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 345.70
        end
      end

      context 'when service is D.6' do
        let(:code) { 'D.6' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 324.55
        end
      end

      context 'when service is E.1' do
        let(:code) { 'E.1' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 2799.72
        end
      end

      context 'when service is E.2' do
        let(:code) { 'E.2' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 1367.57
        end
      end

      context 'when service is E.3' do
        let(:code) { 'E.3' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 2157.81
        end
      end

      context 'when service is E.5' do
        let(:code) { 'E.5' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 344.65
        end
      end

      context 'when service is E.6' do
        let(:code) { 'E.6' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 541.65
        end
      end

      context 'when service is E.7' do
        let(:code) { 'E.7' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 589.28
        end
      end

      context 'when service is E.8' do
        let(:code) { 'E.8' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 349.30
        end
      end

      context 'when service is E.4' do
        let(:code) { 'E.4' }
        let(:no_of_appliances_for_testing) { 110 }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 112.03
        end
      end

      context 'when service is E.9' do
        let(:code) { 'E.9' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.1' do
        let(:code) { 'F.1' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 84.72
        end
      end

      context 'when service is F.2' do
        let(:code) { 'F.2' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.3' do
        let(:code) { 'F.3' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.4' do
        let(:code) { 'F.4' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.5' do
        let(:code) { 'F.5' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.6' do
        let(:code) { 'F.6' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.7' do
        let(:code) { 'F.7' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.8' do
        let(:code) { 'F.8' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.9' do
        let(:code) { 'F.9' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.10' do
        let(:code) { 'F.10' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is G.1' do
        let(:code) { 'G.1' }
        let(:no_of_building_occupants) { 192 }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 17262.04
        end
      end

      context 'when service is G.2' do
        let(:code) { 'G.2' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 353.71
        end
      end

      context 'when service is G.3' do
        let(:code) { 'G.3' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 19475.45
        end
      end

      context 'when service is G.4' do
        let(:code) { 'G.4' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 2349.61
        end
      end

      context 'when service is G.6' do
        let(:code) { 'G.6' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 382.02
        end
      end

      context 'when service is G.7' do
        let(:code) { 'G.7' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 699.30
        end
      end

      context 'when service is G.15' do
        let(:code) { 'G.15' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(nil, nil, nil, procurement)
          selected_buildings = procurement.active_procurement_buildings
          rates = CCS::FM::Rate.read_benchmark_rates
          rate_card = CCS::FM::RateCard.latest
          report.calculate_services_for_buildings selected_buildings, nil, rates, rate_card, nil, nil
          expect(report.assessed_value.round(2)).to eq 493.15
        end
      end
    end
  end
end