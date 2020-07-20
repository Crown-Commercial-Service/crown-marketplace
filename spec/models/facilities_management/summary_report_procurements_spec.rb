require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:procurement) { procurement_building_service.procurement_building.procurement }

  let(:report) { described_class.new(procurement.id) }

  before do
    report.calculate_services_for_buildings
  end

  describe '#assessed_value' do
    let(:code) { nil }
    let(:service_standard) { nil }
    let(:lift_data) { nil }
    let(:no_of_appliances_for_testing) { nil }
    let(:no_of_building_occupants) { nil }
    let(:no_of_consoles_to_be_serviced) { nil }
    let(:tones_to_be_collected_and_removed) { nil }
    let(:no_of_units_to_be_serviced) { nil }
    let(:estimated_annual_cost) { nil }
    let(:estimated_cost_known) { nil }
    let(:service_hours) { { "monday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "tuesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "wednesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "thursday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "friday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "saturday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "sunday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, 'personnel': 1, "uom": 0 } }
    let(:procurement_building_service) do
      create(:facilities_management_procurement_building_service,
             code: code,
             service_standard: service_standard,
             lift_data: lift_data,
             no_of_appliances_for_testing: no_of_appliances_for_testing,
             no_of_building_occupants: no_of_building_occupants,
             no_of_consoles_to_be_serviced: no_of_consoles_to_be_serviced,
             tones_to_be_collected_and_removed: tones_to_be_collected_and_removed,
             no_of_units_to_be_serviced: no_of_units_to_be_serviced,
             service_hours: service_hours,
             procurement_building: create(:facilities_management_procurement_building_no_services,
                                          procurement: create(:facilities_management_procurement_no_procurement_buildings, estimated_annual_cost: estimated_annual_cost, estimated_cost_known: estimated_cost_known)))
    end
    # building gia = 1002

    context 'when one building and one service' do
      context 'when service is C.1 standard A' do
        let(:code) { 'C.1' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4595.71
        end
      end

      context 'when service is C.1 standard B' do
        let(:code) { 'C.1' }
        let(:service_standard) { 'B' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { 1000 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2166.10
        end
      end

      context 'when service is C.1 standard C' do
        let(:code) { 'C.1' }
        let(:service_standard) { 'C' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { 1000 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2166.10
        end
      end

      context 'when service is C.2 standard A' do
        let(:code) { 'C.2' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3098.15
        end
      end

      context 'when service is C.3 standard A' do
        let(:code) { 'C.3' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 251.98
        end
      end

      context 'when service is C.4 standard A' do
        let(:code) { 'C.4' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1208.36
        end
      end

      context 'when service is C.6 standard A' do
        let(:service_standard) { 'A' }
        let(:code) { 'C.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 629.61
        end
      end

      context 'when service is C.7 standard A' do
        let(:code) { 'C.7' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2647.07
        end
      end

      context 'when service is C.11' do
        let(:code) { 'C.11' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 590.91
        end
      end

      context 'when service is C.12' do
        let(:code) { 'C.12' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 697.21
        end
      end

      context 'when service is C.13' do
        let(:code) { 'C.13' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(procurement.id)
          report.calculate_services_for_buildings
          expect(report.assessed_value.round(2)).to eq 351.64
        end
      end

      context 'when service is C.5' do
        let(:code) { 'C.5' }
        let(:service_standard) { 'A' }
        let(:lift_data) { %w[5 5 2 2] }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3628.42
        end
      end

      context 'when service is C.14' do
        let(:code) { 'C.14' }
        let(:service_standard) { 'A' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 744.28
        end
      end

      context 'when service is C.8' do
        let(:code) { 'C.8' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5366.75
        end
      end

      context 'when service is C.9' do
        let(:code) { 'C.9' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1827.87
        end
      end

      context 'when service is C.10' do
        let(:code) { 'C.10' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 712.96
        end
      end

      context 'when service is C.15' do
        let(:code) { 'C.15' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 581.43
        end
      end

      context 'when service is C.16' do
        let(:code) { 'C.16' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 537.58
        end
      end

      context 'when service is C.17' do
        let(:code) { 'C.17' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 531.32
        end
      end

      context 'when service is C.18' do
        let(:code) { 'C.18' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 587.69
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
          expect(report.assessed_value.round(2)).to eq 637.8
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
          expect(report.assessed_value.round(2)).to eq 2830.03
        end
      end

      context 'when service is D.2' do
        let(:code) { 'D.2' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 994.82
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
          expect(report.assessed_value.round(2)).to eq 581.43
        end
      end

      context 'when service is D.5' do
        let(:code) { 'D.5' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 838.23
        end
      end

      context 'when service is D.6' do
        let(:code) { 'D.6' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 813.18
        end
      end

      context 'when service is E.1' do
        let(:code) { 'E.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2727.49
        end
      end

      context 'when service is E.2' do
        let(:code) { 'E.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1332.89
        end
      end

      context 'when service is E.3' do
        let(:code) { 'E.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2098.07
        end
      end

      context 'when service is E.5' do
        let(:code) { 'E.5' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 333.22
        end
      end

      context 'when service is E.6' do
        let(:code) { 'E.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 530.69
        end
      end

      context 'when service is E.7' do
        let(:code) { 'E.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 567.71
        end
      end

      context 'when service is E.8' do
        let(:code) { 'E.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 345.56
        end
      end

      context 'when service is E.4' do
        let(:code) { 'E.4' }
        let(:no_of_appliances_for_testing) { 110 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 108.39
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
          expect(report.assessed_value.round(2)).to eq 581.43
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
          expect(report.assessed_value.round(2)).to eq 16772.9
        end
      end

      context 'when service is G.2' do
        let(:code) { 'G.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 346.12
        end
      end

      context 'when service is G.3 standard A' do
        let(:code) { 'G.3' }
        let(:service_standard) { 'A' }
        let(:no_of_building_occupants) { 192 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 25130.24
        end
      end

      context 'when service is G.4' do
        let(:code) { 'G.4' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2282.83
        end
      end

      context 'when service is G.6' do
        let(:code) { 'G.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 370.43
        end
      end

      context 'when service is G.7' do
        let(:code) { 'G.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 681.2
        end
      end

      context 'when service is G.15' do
        let(:code) { 'G.15' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 482.25
        end
      end

      context 'when service is G.5' do
        let(:code) { 'G.5' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 14888.07
        end
      end

      context 'when service is G.9' do
        let(:code) { 'G.9' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 769.33
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
          expect(report.assessed_value.round(2)).to eq 1345.58
        end
      end

      context 'when service is G.11' do
        let(:code) { 'G.11' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 556.37
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
          expect(report.assessed_value.round(2)).to eq 694.17
        end
      end

      context 'when service is G.16' do
        let(:code) { 'G.16' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2422.9
        end
      end

      context 'when service is H.4' do
        let(:code) { 'H.4' }
        # 1820 service hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 44788.8
        end
      end

      context 'when service is H.5' do
        let(:code) { 'H.5' }
        # 1820 service hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 36696.33
        end
      end

      context 'when service is H.7' do
        let(:code) { 'H.7' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 556.37
        end
      end

      context 'when service is H.1' do
        let(:code) { 'H.1' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1527.22
        end
      end

      context 'when service is H.2' do
        let(:code) { 'H.2' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1846.66
        end
      end

      context 'when service is H.3' do
        let(:code) { 'H.3' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 644.06
        end
      end

      context 'when service is H.6' do
        let(:code) { 'H.6' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1195.25
        end
      end

      context 'when service is H.8' do
        let(:code) { 'H.8' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 506.26
        end
      end

      context 'when service is H.10' do
        let(:code) { 'H.10' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 619.01
        end
      end

      context 'when service is H.11' do
        let(:code) { 'H.11' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1138.88
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
          expect(report.assessed_value.round(2)).to eq 4095.26
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
        # 1820 service_hours
        let(:code) { 'I.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 31249.04
        end
      end

      context 'when service is I.2' do
        # 1820 service_hours
        let(:code) { 'I.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29814.37
        end
      end

      context 'when service is I.3' do
        # 1820 service_hours
        let(:code) { 'I.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29904.03
        end
      end

      context 'when service is I.4' do
        # 1820 service_hours
        let(:code) { 'I.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 30016.12
        end
      end

      context 'when service is J.1' do
        let(:code) { 'J.1' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 28648.69
        end
      end

      context 'when service is J.2' do
        let(:code) { 'J.2' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29321.2
        end
      end

      context 'when service is J.3' do
        let(:code) { 'J.3' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29164.28
        end
      end

      context 'when service is J.4' do
        let(:code) { 'J.4' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 32795.8
        end
      end

      context 'when service is J.5' do
        let(:code) { 'J.5' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29433.28
        end
      end

      context 'when service is J.6' do
        let(:code) { 'J.6' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29186.7
        end
      end

      context 'when service is J.7' do
        let(:code) { 'J.7' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 587.69
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
          expect(report.assessed_value.round(2)).to eq 1414.47
        end
      end

      context 'when service is J.10' do
        let(:code) { 'J.10' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 863.28
        end
      end

      context 'when service is J.11' do
        let(:code) { 'J.11' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 988.55
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
          expect(report.assessed_value.round(2)).to eq 6115.04
        end
      end

      context 'when service is K.3' do
        let(:code) { 'K.3' }
        let(:tones_to_be_collected_and_removed) { 2 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 441.44
        end
      end

      context 'when service is K.1' do
        let(:code) { 'K.1' }
        let(:no_of_consoles_to_be_serviced) { 22 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2570.72
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
          expect(report.assessed_value.round(2)).to eq 631.53
        end
      end

      context 'when service is L.3' do
        let(:code) { 'L.3' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 6168.49
        end
      end

      context 'when service is L.4' do
        let(:code) { 'L.4' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 656.59
        end
      end

      context 'when service is L.5' do
        let(:code) { 'L.5' }
        let(:estimated_annual_cost) { 1000 }
        let(:estimated_cost_known) { true }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 568.9
        end
      end
    end

    context 'when estimated anual cost is not known' do
      context 'when service is C.14' do
        let(:code) { 'C.14' }
        let(:service_standard) { 'A' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 488.55
        end
      end

      context 'when service is C.9' do
        let(:code) { 'C.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2655.73
        end
      end

      context 'when service is C.15' do
        let(:code) { 'C.15' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 162.85
        end
      end

      context 'when service is C.17' do
        let(:code) { 'C.17' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 62.64
        end
      end

      context 'when service is C.20' do
        let(:code) { 'C.20' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 275.59
        end
      end

      context 'when service is D.4' do
        let(:code) { 'D.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 162.85
        end
      end

      context 'when service is D.6' do
        let(:code) { 'D.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 626.35
        end
      end

      context 'when service is F.1' do
        let(:code) { 'F.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 162.85
        end
      end

      context 'when service is G.9' do
        let(:code) { 'G.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 538.66
        end
      end

      context 'when service is G.11' do
        let(:code) { 'G.11' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 112.74
        end
      end

      context 'when service is G.16' do
        let(:code) { 'G.16' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3845.8
        end
      end

      context 'when service is H.7' do
        let(:code) { 'H.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 112.74
        end
      end

      context 'when service is H.2' do
        let(:code) { 'H.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2693.31
        end
      end

      context 'when service is H.6' do
        let(:code) { 'H.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1390.5
        end
      end

      context 'when service is H.10' do
        let(:code) { 'H.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 238.01
        end
      end

      context 'when service is H.13' do
        let(:code) { 'H.13' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 7190.52
        end
      end

      context 'when service is J.7' do
        let(:code) { 'J.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 175.38
        end
      end

      context 'when service is J.10' do
        let(:code) { 'J.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 726.57
        end
      end

      context 'when service is L.2' do
        let(:code) { 'L.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 263.07
        end
      end

      context 'when service is L.4' do
        let(:code) { 'L.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 313.18
        end
      end
    end

    context 'when tupe is true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings, tupe: true)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5035.53
        end
      end
    end

    context 'when London location' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5460.17
        end
      end
    end

    context 'when CAFM true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:cafm_procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'M.1',
               procurement_building: procurement_building_service.procurement_building)
      end
      let(:procurement) { cafm_procurement_building_service.procurement_building.procurement }

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4662.35
        end
      end
    end

    context 'when Helpdesk true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:helpdesk_procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'N.1',
               procurement_building: procurement_building_service.procurement_building)
      end
      let(:procurement) { helpdesk_procurement_building_service.procurement_building.procurement }

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4733.13
        end
      end
    end

    context 'when estimated value is known' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings,
                                                                estimated_cost_known: true,
                                                                estimated_annual_cost: 5500)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4897.14
        end
      end
    end

    context 'when procurement initial call of period is for 2 years' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings, initial_call_off_period: 2)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 9089.36
        end
      end
    end

    context 'when multiple buildings' do
      let(:service_hours) { { "monday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "tuesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "wednesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "thursday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "friday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "saturday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "sunday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, personnel: 1, "uom": 0 } }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'C.11',
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:procurement_building_service_1) do
        create(:facilities_management_procurement_building_service,
               code: 'J.5',
               service_hours: service_hours,
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: procurement_building_service.procurement_building.procurement))
      end
      let(:procurement) { procurement_building_service_1.procurement_building.procurement }

      it 'returns the right assessed value' do
        expect(report.assessed_value.round(2)).to eq 30024.19
      end
    end

    context 'when multiple services with benchmark cost but no buyer input' do
      let(:procurement_building_service_c11) do
        create(:facilities_management_procurement_building_service,
               code: 'C.11',
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings, estimated_cost_known: false)))
      end
      let(:procurement_building_service_c4) do
        create(:facilities_management_procurement_building_service,
               code: 'C.4',
               service_standard: 'A',
               procurement_building: procurement_building_service_c11.procurement_building)
      end
      let(:procurement_building_service_l2) do
        create(:facilities_management_procurement_building_service,
               code: 'L.2',
               service_standard: 'A',
               procurement_building: procurement_building_service_c4.procurement_building)
      end

      context 'when the variance is over 30%' do
        let(:procurement_building_service_d1) do
          create(:facilities_management_procurement_building_service,
                 code: 'D.1',
                 procurement_building: procurement_building_service_l2.procurement_building)
        end

        let(:procurement) { procurement_building_service_d1.procurement_building.procurement }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 7813.77
        end
      end

      context 'when the variance is under 30%' do
        let(:procurement) { procurement_building_service_l2.procurement_building.procurement }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2293.99
        end
      end
    end
  end

  describe '#selected_suppliers' do
    context 'when region is UKH1' do
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'C.1',
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:supplier_name) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service.procurement_building.building.address_region_code] - l['regions']).empty? &&
              ([procurement_building_service.code] - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_region) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service.procurement_building.building.address_region_code] - l['regions']).any? &&
              ([procurement_building_service.code] - l['services']).empty?
          end
        end.last.data['supplier_name']
      end

      it 'shows suppliers that do provide the service in UKH1 region' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name)).to eq true
      end

      it 'does not show the suppliers that do not provide the service in UKH1 region' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name_no_region)).to eq false
      end
    end

    context 'when service is L.2' do
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'L.2',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:supplier_name) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service.procurement_building.building.address_region_code] - l['regions']).empty? &&
              ([procurement_building_service.code] - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_service) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service.procurement_building.building.address_region_code] - l['regions']).empty? &&
              ([procurement_building_service.code] - l['services']).any?
          end
        end.last.data['supplier_name']
      end

      it 'shows suppliers that do provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name)).to eq true
      end

      it 'does not show the suppliers that do not provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name_no_service)).to eq false
      end
    end

    context 'when multiple services' do
      let(:procurement_building_service_c1) do
        create(:facilities_management_procurement_building_service,
               code: 'C.1',
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings, estimated_cost_known: true, estimated_annual_cost: 1000)))
      end
      let(:procurement_building_service_c2) do
        create(:facilities_management_procurement_building_service,
               code: 'C.2',
               service_standard: 'A',
               procurement_building: procurement_building_service_c1.procurement_building)
      end
      let(:procurement_building_service_c3) do
        create(:facilities_management_procurement_building_service,
               code: 'C.3',
               service_standard: 'A',
               procurement_building: procurement_building_service_c2.procurement_building)
      end
      let(:procurement_building_service_c21) do
        create(:facilities_management_procurement_building_service,
               code: 'C.21',
               procurement_building: procurement_building_service_c3.procurement_building)
      end
      let(:procurement_building_service_c22) do
        create(:facilities_management_procurement_building_service,
               code: 'C.22',
               procurement_building: procurement_building_service_c21.procurement_building)
      end

      let(:procurement) { procurement_building_service_c22.procurement_building.procurement }
      let(:supplier_name) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service_c1.procurement_building.building.address_region_code] - l['regions']).empty? &&
              (procurement.procurement_building_services.map(&:code) - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_service) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service_c1.procurement_building.building.address_region_code] - l['regions']).empty? &&
              (procurement.procurement_building_services.map(&:code) - l['services']).any?
          end
        end.last.data['supplier_name']
      end

      it 'shows suppliers that do provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name)).to eq true
      end

      it 'does not show the suppliers that do not provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name_no_service)).to eq false
      end
    end

    context 'when multiple regions' do
      let(:procurement_building_service_c5) do
        create(:facilities_management_procurement_building_service,
               code: 'C.5',
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:procurement_building_service_c6) do
        create(:facilities_management_procurement_building_service,
               code: 'C.6',
               service_standard: 'A',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end

      let(:procurement) { procurement_building_service_c6.procurement_building.procurement }
      let(:supplier_name) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              (procurement.procurement_buildings.map { |pb| pb.building.address_region_code } - l['regions']).empty? &&
              (procurement.procurement_building_services.map(&:code) - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_service) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              (procurement.procurement_building_services.map { |pb| pb.procurement_building.building.address_region_code } - l['regions']).any? &&
              (procurement.procurement_building_services.map(&:code) - l['services']).empty?
          end
        end.last.data['supplier_name']
      end

      it 'shows suppliers that do provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name)).to eq true
      end

      it 'does not show the suppliers that do not provide the specific service' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name_no_service)).to eq false
      end
    end

    context 'when lot 1b' do
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'C.5',
               service_standard: 'A',
               lift_data: %w[1000 1000 1000 1000],
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings, initial_call_off_period: 7)))
      end
      let(:supplier_name) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1b') &&
              ([procurement_building_service.procurement_building.building.address_region_code] - l['regions']).empty? &&
              ([procurement_building_service.code] - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_lot1a) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              !((l['lot_number'] == '1b') &&
                ([procurement_building_service.procurement_building.building.address_region_code] - l['regions']).empty? &&
                ([procurement_building_service.code] - l['services']).empty?)
          end
        end.first.data['supplier_name']
      end

      it 'shows suppliers that do provide the service in lot1b' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name)).to eq true
      end

      it 'does not show the suppliers that provide the services in lot1a not lot1b' do
        expect(report.selected_suppliers(report.current_lot).map { |s| s.data['supplier_name'] }.include?(supplier_name_lot1a)).to eq false
      end
    end
  end
end
