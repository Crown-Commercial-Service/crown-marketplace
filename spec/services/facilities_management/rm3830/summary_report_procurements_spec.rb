require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:procurement) { procurement_building_service.procurement_building.procurement }

  let(:report) { described_class.new(procurement.id) }

  let(:lift_data) { [] }

  before do
    procurement.send(:copy_procurement_buildings_data)
    lift_data&.each do |number_of_floors|
      procurement_building_service.lifts.create(number_of_floors:)
    end
    report.calculate_services_for_buildings
  end

  describe '#assessed_value' do
    let(:code) { nil }
    let(:service_standard) { nil }
    let(:no_of_appliances_for_testing) { nil }
    let(:no_of_building_occupants) { nil }
    let(:no_of_consoles_to_be_serviced) { nil }
    let(:tones_to_be_collected_and_removed) { nil }
    let(:no_of_units_to_be_serviced) { nil }
    let(:estimated_annual_cost) { nil }
    let(:estimated_cost_known) { nil }
    let(:service_hours) { nil }
    let(:procurement_building_service) do
      create(:facilities_management_rm3830_procurement_building_service,
             code: code,
             service_standard: service_standard,
             no_of_appliances_for_testing: no_of_appliances_for_testing,
             no_of_building_occupants: no_of_building_occupants,
             no_of_consoles_to_be_serviced: no_of_consoles_to_be_serviced,
             tones_to_be_collected_and_removed: tones_to_be_collected_and_removed,
             no_of_units_to_be_serviced: no_of_units_to_be_serviced,
             service_hours: service_hours,
             procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                          procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, estimated_annual_cost:, estimated_cost_known:)))
    end

    context 'when one building and one service' do
      context 'when service is C.1 standard A' do
        let(:code) { 'C.1' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4602.0
        end
      end

      context 'when service is C.1 standard B' do
        let(:code) { 'C.1' }
        let(:service_standard) { 'B' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2172.38
        end
      end

      context 'when service is C.1 standard C' do
        let(:code) { 'C.1' }
        let(:service_standard) { 'C' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2172.38
        end
      end

      context 'when service is C.2 standard A' do
        let(:code) { 'C.2' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3104.91
        end
      end

      context 'when service is C.3 standard A' do
        let(:code) { 'C.3' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 252.34
        end
      end

      context 'when service is C.4 standard A' do
        let(:code) { 'C.4' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1210.54
        end
      end

      context 'when service is C.6 standard A' do
        let(:service_standard) { 'A' }
        let(:code) { 'C.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 630.83
        end
      end

      context 'when service is C.7 standard A' do
        let(:code) { 'C.7' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2653.67
        end
      end

      context 'when service is C.11' do
        let(:code) { 'C.11' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 591.86
        end
      end

      context 'when service is C.12' do
        let(:code) { 'C.12' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 698.53
        end
      end

      context 'when service is C.13' do
        let(:code) { 'C.13' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 352.30
        end
      end

      context 'when service is C.5' do
        let(:code) { 'C.5' }
        let(:service_standard) { 'A' }
        let(:lift_data) { [5, 5, 2, 2] }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3635.37
        end
      end

      context 'when service is C.14' do
        let(:code) { 'C.14' }
        let(:service_standard) { 'A' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 745.2
        end
      end

      context 'when service is C.8' do
        let(:code) { 'C.8' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5385.12
        end
      end

      context 'when service is C.9' do
        let(:code) { 'C.9' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1832.88
        end
      end

      context 'when service is C.10' do
        let(:code) { 'C.10' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 713.76
        end
      end

      context 'when service is C.15' do
        let(:code) { 'C.15' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 581.73
        end
      end

      context 'when service is C.16' do
        let(:code) { 'C.16' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 537.72
        end
      end

      context 'when service is C.17' do
        let(:code) { 'C.17' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 531.44
        end
      end

      context 'when service is C.18' do
        let(:code) { 'C.18' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 588.02
        end
      end

      context 'when service is C.19' do
        let(:code) { 'C.19' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is C.20' do
        let(:code) { 'C.20' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 638.32
        end
      end

      context 'when service is C.21' do
        let(:code) { 'C.21' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is C.22' do
        let(:code) { 'C.22' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is D.1' do
        let(:code) { 'D.1' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2838.82
        end
      end

      context 'when service is D.2' do
        let(:code) { 'D.2' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 996.69
        end
      end

      context 'when service is D.3' do
        let(:code) { 'D.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0
        end
      end

      context 'when service is D.4' do
        let(:code) { 'D.4' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 581.73
        end
      end

      context 'when service is D.5' do
        let(:code) { 'D.5' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 839.51
        end
      end

      context 'when service is D.6' do
        let(:code) { 'D.6' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 814.36
        end
      end

      context 'when service is E.1' do
        let(:code) { 'E.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2732.71
        end
      end

      context 'when service is E.2' do
        let(:code) { 'E.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1335.44
        end
      end

      context 'when service is E.3' do
        let(:code) { 'E.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2102.08
        end
      end

      context 'when service is E.5' do
        let(:code) { 'E.5' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 333.86
        end
      end

      context 'when service is E.6' do
        let(:code) { 'E.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 531.70
        end
      end

      context 'when service is E.7' do
        let(:code) { 'E.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 568.80
        end
      end

      context 'when service is E.8' do
        let(:code) { 'E.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 346.23
        end
      end

      context 'when service is E.4' do
        let(:code) { 'E.4' }
        let(:no_of_appliances_for_testing) { 110 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 108.60
        end
      end

      context 'when service is E.9' do
        let(:code) { 'E.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.1' do
        let(:code) { 'F.1' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 581.73
        end
      end

      context 'when service is F.2' do
        let(:code) { 'F.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.3' do
        let(:code) { 'F.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.4' do
        let(:code) { 'F.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.5' do
        let(:code) { 'F.5' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.6' do
        let(:code) { 'F.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.7' do
        let(:code) { 'F.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.8' do
        let(:code) { 'F.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.9' do
        let(:code) { 'F.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is F.10' do
        let(:code) { 'F.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is G.1 standard A' do
        let(:code) { 'G.1' }
        let(:service_standard) { 'A' }
        let(:no_of_building_occupants) { 192 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 16797.02
        end
      end

      context 'when service is G.2' do
        let(:code) { 'G.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 346.85
        end
      end

      context 'when service is G.3 standard A' do
        let(:code) { 'G.3' }
        let(:service_standard) { 'A' }
        let(:no_of_building_occupants) { 192 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 25178.37
        end
      end

      context 'when service is G.4' do
        let(:code) { 'G.4' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2284.06
        end
      end

      context 'when service is G.6' do
        let(:code) { 'G.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 371.17
        end
      end

      context 'when service is G.7' do
        let(:code) { 'G.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 682.80
        end
      end

      context 'when service is G.15' do
        let(:code) { 'G.15' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 483.29
        end
      end

      context 'when service is G.5' do
        let(:code) { 'G.5' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 14916.58
        end
      end

      context 'when service is G.9' do
        let(:code) { 'G.9' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 770.35
        end
      end

      context 'when service is G.8' do
        let(:code) { 'G.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is G.10' do
        let(:code) { 'G.10' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1348.77
        end
      end

      context 'when service is G.11' do
        let(:code) { 'G.11' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 556.58
        end
      end

      context 'when service is G.12' do
        let(:code) { 'G.12' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is G.13' do
        let(:code) { 'G.13' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is G.14' do
        let(:code) { 'G.14' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 694.90
        end
      end

      context 'when service is G.16' do
        let(:code) { 'G.16' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2430.16
        end
      end

      context 'when service is H.4' do
        let(:code) { 'H.4' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 44874.58
        end
      end

      context 'when service is H.5' do
        let(:code) { 'H.5' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 36766.61
        end
      end

      context 'when service is H.7' do
        let(:code) { 'H.7' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 556.58
        end
      end

      context 'when service is H.1' do
        let(:code) { 'H.1' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1531.09
        end
      end

      context 'when service is H.2' do
        let(:code) { 'H.2' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1851.74
        end
      end

      context 'when service is H.3' do
        let(:code) { 'H.3' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 644.60
        end
      end

      context 'when service is H.6' do
        let(:code) { 'H.6' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1197.87
        end
      end

      context 'when service is H.8' do
        let(:code) { 'H.8' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 506.29
        end
      end

      context 'when service is H.10' do
        let(:code) { 'H.10' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 619.46
        end
      end

      context 'when service is H.11' do
        let(:code) { 'H.11' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1141.29
        end
      end

      context 'when service is H.12' do
        let(:code) { 'H.12' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is H.13' do
        let(:code) { 'H.13' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4108.83
        end
      end

      context 'when service is H.14' do
        let(:code) { 'H.14' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is H.15' do
        let(:code) { 'H.15' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is H.16' do
        let(:code) { 'H.16' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is I.1' do
        let(:code) { 'I.1' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 31308.89
        end
      end

      context 'when service is I.2' do
        let(:code) { 'I.2' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29871.47
        end
      end

      context 'when service is I.3' do
        let(:code) { 'I.3' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29961.31
        end
      end

      context 'when service is I.4' do
        let(:code) { 'I.4' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 30073.60
        end
      end

      context 'when service is J.1' do
        let(:code) { 'J.1' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 28703.56
        end
      end

      context 'when service is J.2' do
        let(:code) { 'J.2' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29377.35
        end
      end

      context 'when service is J.3' do
        let(:code) { 'J.3' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29220.13
        end
      end

      context 'when service is J.4' do
        let(:code) { 'J.4' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 32858.61
        end
      end

      context 'when service is J.5' do
        let(:code) { 'J.5' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29489.65
        end
      end

      context 'when service is J.6' do
        let(:code) { 'J.6' }
        let(:service_hours) { 1820 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29242.59
        end
      end

      context 'when service is J.7' do
        let(:code) { 'J.7' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 588.02
        end
      end

      context 'when service is J.8' do
        let(:code) { 'J.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.0
        end
      end

      context 'when service is J.9' do
        let(:code) { 'J.9' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1417.92
        end
      end

      context 'when service is J.10' do
        let(:code) { 'J.10' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 864.66
        end
      end

      context 'when service is J.11' do
        let(:code) { 'J.11' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 990.40
        end
      end

      context 'when service is J.12' do
        let(:code) { 'J.12' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is K.2' do
        let(:code) { 'K.2' }
        let(:tones_to_be_collected_and_removed) { 22 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 6126.75
        end
      end

      context 'when service is K.3' do
        let(:code) { 'K.3' }
        let(:tones_to_be_collected_and_removed) { 2 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 442.28
        end
      end

      context 'when service is K.1' do
        let(:code) { 'K.1' }
        let(:no_of_consoles_to_be_serviced) { 22 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2575.64
        end
      end

      context 'when service is K.4' do
        let(:code) { 'K.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is K.5' do
        let(:code) { 'K.5' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is K.6' do
        let(:code) { 'K.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is L.1' do
        let(:code) { 'L.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 0.00
        end
      end

      context 'when service is L.2' do
        let(:code) { 'L.2' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 632.03
        end
      end

      context 'when service is L.3' do
        let(:code) { 'L.3' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 6189.88
        end
      end

      context 'when service is L.4' do
        let(:code) { 'L.4' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 657.18
        end
      end

      context 'when service is L.5' do
        let(:code) { 'L.5' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 569.16
        end
      end
    end

    context 'when estimated annual cost is not known' do
      context 'when service is C.14' do
        let(:code) { 'C.14' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 490.40
        end
      end

      context 'when service is C.9' do
        let(:code) { 'C.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2665.75
        end
      end

      context 'when service is C.15' do
        let(:code) { 'C.15' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 163.47
        end
      end

      context 'when service is C.17' do
        let(:code) { 'C.17' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 62.87
        end
      end

      context 'when service is C.20' do
        let(:code) { 'C.20' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 276.63
        end
      end

      context 'when service is D.4' do
        let(:code) { 'D.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 163.47
        end
      end

      context 'when service is D.6' do
        let(:code) { 'D.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 628.72
        end
      end

      context 'when service is F.1' do
        let(:code) { 'F.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 163.47
        end
      end

      context 'when service is G.9' do
        let(:code) { 'G.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 540.70
        end
      end

      context 'when service is G.11' do
        let(:code) { 'G.11' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 113.17
        end
      end

      context 'when service is G.16' do
        let(:code) { 'G.16' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3860.31
        end
      end

      context 'when service is H.7' do
        let(:code) { 'H.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 113.17
        end
      end

      context 'when service is H.2' do
        let(:code) { 'H.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2703.48
        end
      end

      context 'when service is H.6' do
        let(:code) { 'H.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1395.75
        end
      end

      context 'when service is H.10' do
        let(:code) { 'H.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 238.91
        end
      end

      context 'when service is H.13' do
        let(:code) { 'H.13' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 7217.66
        end
      end

      context 'when service is J.7' do
        let(:code) { 'J.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 176.04
        end
      end

      context 'when service is J.10' do
        let(:code) { 'J.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 729.31
        end
      end

      context 'when service is L.2' do
        let(:code) { 'L.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 264.06
        end
      end

      context 'when service is L.4' do
        let(:code) { 'L.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 314.36
        end
      end
    end

    context 'when tupe is true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, tupe: true, estimated_cost_known: false)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5028.04
        end
      end
    end

    context 'when London location' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, estimated_cost_known: false)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5467.64
        end
      end
    end

    context 'when CAFM true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, estimated_cost_known: false)))
      end
      let(:cafm_procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'M.1',
               procurement_building: procurement_building_service.procurement_building)
      end
      let(:procurement) { cafm_procurement_building_service.procurement_building.procurement }

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4668.73
        end
      end
    end

    context 'when Helpdesk true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, estimated_cost_known: false)))
      end
      let(:helpdesk_procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'N.1',
               procurement_building: procurement_building_service.procurement_building)
      end
      let(:procurement) { helpdesk_procurement_building_service.procurement_building.procurement }

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4739.60
        end
      end
    end

    context 'when estimated value is known' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings,
                                                                estimated_cost_known: true,
                                                                estimated_annual_cost: 5500)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4901.33
        end
      end
    end

    context 'when procurement initial call of period is for 2 years' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, initial_call_off_period_years: 2, estimated_cost_known: false)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 9101.93
        end
      end
    end

    context 'when multiple buildings' do
      let(:service_hours) { 1820 }
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.11',
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, estimated_cost_known: false)))
      end
      let(:procurement_building_service_1) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'J.5',
               service_hours: service_hours,
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: procurement_building_service.procurement_building.procurement))
      end
      let(:procurement) { procurement_building_service_1.procurement_building.procurement }

      it 'returns the right assessed value' do
        expect(report.assessed_value.round(2)).to eq 30081.51
      end
    end

    context 'when multiple services with benchmark cost but no buyer input' do
      let(:procurement_building_service_c11) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.11',
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, estimated_cost_known: false)))
      end
      let(:procurement_building_service_c4) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.4',
               service_standard: 'A',
               procurement_building: procurement_building_service_c11.procurement_building)
      end
      let(:procurement_building_service_l2) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'L.2',
               service_standard: 'A',
               procurement_building: procurement_building_service_c4.procurement_building)
      end

      context 'when the variance is over 30%' do
        let(:procurement_building_service_d1) do
          create(:facilities_management_rm3830_procurement_building_service,
                 code: 'D.1',
                 procurement_building: procurement_building_service_l2.procurement_building)
        end

        let(:procurement) { procurement_building_service_d1.procurement_building.procurement }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 7843.26
        end
      end

      context 'when the variance is under 30%' do
        let(:procurement) { procurement_building_service_l2.procurement_building.procurement }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2298.29
        end
      end
    end
  end

  describe '#selected_suppliers' do
    def selected_suppliers_for_no_region(for_lot, for_regions, for_services)
      FacilitiesManagement::RM3830::SupplierDetail.all.select do |s|
        s.lot_data[for_lot] && (for_regions - s.lot_data[for_lot]['regions']).any? && (for_services - s.lot_data[for_lot]['services']).empty?
      end
    end

    context 'when region is UKH1' do
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.1',
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings)))
      end
      let(:supplier_name) do
        FacilitiesManagement::RM3830::SupplierDetail.selected_suppliers('1a', [procurement_building_service.procurement_building.building.address_region_code], [procurement_building_service.code]).first.supplier_name
      end

      let(:supplier_name_no_region) do
        selected_suppliers_for_no_region('1a', [procurement_building_service.procurement_building.building.address_region_code], [procurement_building_service.code]).last.supplier_name
      end

      before do
        procurement_building_service.procurement_building.freeze_building_data
      end

      it 'shows suppliers that do provide the service in UKH1 region' do
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name)).to be true
      end

      it 'does not show the suppliers that do not provide the service in UKH1 region' do
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name_no_region)).to be false
      end
    end

    context 'when service is L.2' do
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'L.2',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings)))
      end
      let(:supplier_name) do
        FacilitiesManagement::RM3830::SupplierDetail.selected_suppliers('1a', [procurement_building_service.procurement_building.building.address_region_code], [procurement_building_service.code]).first.supplier_name
      end

      let(:supplier_name_no_service) do
        selected_suppliers_for_no_region('1a', [procurement_building_service.procurement_building.building.address_region_code], [procurement_building_service.code]).last.supplier_name
      end

      before do
        procurement_building_service.procurement_building.freeze_building_data
      end

      it 'shows suppliers that do provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name)).to be true
      end

      it 'does not show the suppliers that do not provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name_no_service)).to be false
      end
    end

    context 'when multiple services' do
      let(:procurement_building_service_c1) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.1',
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, estimated_cost_known: true, estimated_annual_cost: 1000)))
      end
      let(:procurement_building_service_c2) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.2',
               service_standard: 'A',
               procurement_building: procurement_building_service_c1.procurement_building)
      end
      let(:procurement_building_service_c3) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.3',
               service_standard: 'A',
               procurement_building: procurement_building_service_c2.procurement_building)
      end
      let(:procurement_building_service_c21) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.21',
               procurement_building: procurement_building_service_c3.procurement_building)
      end
      let(:procurement_building_service_c22) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.22',
               procurement_building: procurement_building_service_c21.procurement_building)
      end

      let(:procurement) { procurement_building_service_c22.procurement_building.procurement }
      let(:supplier_name) do
        FacilitiesManagement::RM3830::SupplierDetail.selected_suppliers('1a', [procurement_building_service_c1.procurement_building.building.address_region_code], procurement.procurement_building_services.map(&:code)).first.supplier_name
      end

      let(:supplier_name_no_service) do
        selected_suppliers_for_no_region('1a', [procurement_building_service_c1.procurement_building.building.address_region_code], procurement.procurement_building_services.map(&:code)).last.supplier_name
      end

      before do
        procurement.active_procurement_buildings.each(&:freeze_building_data)
      end

      it 'shows suppliers that do provide the specific service' do
        report = described_class.new(procurement.id)
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name)).to be true
      end

      it 'does not show the suppliers that do not provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name_no_service)).to be false
      end
    end

    context 'when multiple regions' do
      let(:procurement_building_service_c5) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.5',
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings)))
      end
      let(:procurement_building_service_c6) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.6',
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings)))
      end

      let(:procurement) { procurement_building_service_c6.procurement_building.procurement }
      let(:supplier_name) do
        FacilitiesManagement::RM3830::SupplierDetail.selected_suppliers('1a', procurement.procurement_buildings.map { |pb| pb.building.address_region_code }, procurement.procurement_building_services.map(&:code)).first.supplier_name
      end

      let(:supplier_name_no_service) do
        selected_suppliers_for_no_region('1a', procurement.procurement_building_services.map { |pb| pb.procurement_building.building.address_region_code }, procurement.procurement_building_services.map(&:code)).last.supplier_name
      end

      before do
        procurement.active_procurement_buildings.each(&:freeze_building_data)
      end

      it 'shows suppliers that do provide the specific service' do
        report = described_class.new(procurement.id)
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name)).to be true
      end

      it 'does not show the suppliers that do not provide the specific service' do
        report = described_class.new(procurement.id)
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name_no_service)).to be false
      end
    end

    context 'when lot 1b' do
      let(:procurement_building_service) do
        create(:facilities_management_rm3830_procurement_building_service,
               code: 'C.5',
               service_standard: 'A',
               procurement_building: create(:facilities_management_rm3830_procurement_building_no_services,
                                            procurement: create(:facilities_management_rm3830_procurement_no_procurement_buildings, initial_call_off_period_years: 7)))
      end
      let(:supplier_name) do
        FacilitiesManagement::RM3830::SupplierDetail.selected_suppliers('1a', [procurement_building_service.procurement_building.address_region_code], [procurement_building_service.code]).first.supplier_name
      end

      let(:supplier_name_lot1a) do
        FacilitiesManagement::RM3830::SupplierDetail.all.select do |s|
          s.lot_data['1a'] && s.lot_data['1b'].nil? && ([procurement_building_service.procurement_building.address_region_code] - s.lot_data['1a']['regions']).any? && ([procurement_building_service.code] - s.lot_data['1a']['services']).empty?
        end.first.supplier_name
      end

      let(:lift_data) { [999, 999, 999, 999] }

      before do
        procurement_building_service.procurement_building.freeze_building_data
        lift_data.each do |number_of_floors|
          procurement_building_service.lifts.create(number_of_floors:)
        end
      end

      it 'shows suppliers that do provide the service in lot1b' do
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name)).to be true
      end

      it 'does not show the suppliers that provide the services in lot1a not lot1b' do
        expect(report.selected_suppliers(report.current_lot).map(&:supplier_name).include?(supplier_name_lot1a)).to be false
      end
    end
  end
end
