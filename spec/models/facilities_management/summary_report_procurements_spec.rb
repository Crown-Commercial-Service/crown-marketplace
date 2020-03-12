require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:procurement) { procurement_building_service.procurement_building.procurement }

  let(:report) { described_class.new(procurement) }

  before do
    report.calculate_services_for_buildings procurement.active_procurement_buildings
  end

  describe '#assessed_value' do
    context 'when one building and one service' do
      let(:code) { nil }
      let(:lift_data) { nil }
      let(:no_of_appliances_for_testing) { nil }
      let(:no_of_building_occupants) { nil }
      let(:size_of_external_area) { nil }
      let(:no_of_consoles_to_be_serviced) { nil }
      let(:tones_to_be_collected_and_removed) { nil }
      let(:no_of_units_to_be_serviced) { nil }
      let(:service_hours) { { "monday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "tuesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "wednesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "thursday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "friday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "saturday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "sunday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "uom": 0 } }
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
               service_hours: service_hours,
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      # building gia = 1002

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4546.28
        end
      end

      context 'when service is C.2' do
        let(:code) { 'C.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3107.06
        end
      end

      context 'when service is C.3' do
        let(:code) { 'C.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 248.92
        end
      end

      context 'when service is C.4' do
        let(:code) { 'C.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1208.56
        end
      end

      context 'when service is C.6' do
        let(:code) { 'C.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 631.74
        end
      end

      context 'when service is C.7' do
        let(:code) { 'C.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2662.70
        end
      end

      context 'when service is C.11' do
        let(:code) { 'C.11' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 587.82
        end
      end

      context 'when service is C.12' do
        let(:code) { 'C.12' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 695.10
        end
      end

      context 'when service is C.13' do
        let(:code) { 'C.13' }

        it 'returns the right assessed value' do
          procurement = procurement_building_service.procurement_building.procurement
          report = FacilitiesManagement::SummaryReport.new(procurement)
          selected_buildings = procurement.active_procurement_buildings
          report.calculate_services_for_buildings selected_buildings
          expect(report.assessed_value.round(2)).to eq 351.87
        end
      end

      context 'when service is C.5' do
        let(:code) { 'C.5' }
        let(:lift_data) { %w[5 5 2 2] }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3619.32
        end
      end

      context 'when service is C.14' do
        let(:code) { 'C.14' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 251.59
        end
      end

      context 'when service is C.8' do
        let(:code) { 'C.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4995.73
        end
      end

      context 'when service is C.9' do
        let(:code) { 'C.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1365.26
        end
      end

      context 'when service is C.10' do
        let(:code) { 'C.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 218.33
        end
      end

      context 'when service is C.15' do
        let(:code) { 'C.15' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 85.95
        end
      end

      context 'when service is C.16' do
        let(:code) { 'C.16' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 39.79
        end
      end

      context 'when service is C.17' do
        let(:code) { 'C.17' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 35.23
        end
      end

      context 'when service is C.18' do
        let(:code) { 'C.18' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 92.72
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 142.79
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2391.78
        end
      end

      context 'when service is D.2' do
        let(:code) { 'D.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 506.85
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 83.68
        end
      end

      context 'when service is D.5' do
        let(:code) { 'D.5' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 345.70
        end
      end

      context 'when service is D.6' do
        let(:code) { 'D.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 324.55
        end
      end

      context 'when service is E.1' do
        let(:code) { 'E.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2715.40
        end
      end

      context 'when service is E.2' do
        let(:code) { 'E.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1326.39
        end
      end

      context 'when service is E.3' do
        let(:code) { 'E.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2092.82
        end
      end

      context 'when service is E.5' do
        let(:code) { 'E.5' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 334.27
        end
      end

      context 'when service is E.6' do
        let(:code) { 'E.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 525.34
        end
      end

      context 'when service is E.7' do
        let(:code) { 'E.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 571.54
        end
      end

      context 'when service is E.8' do
        let(:code) { 'E.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 338.78
        end
      end

      context 'when service is E.4' do
        let(:code) { 'E.4' }
        let(:no_of_appliances_for_testing) { 110 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 108.65
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 84.72
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

      context 'when service is G.1' do
        let(:code) { 'G.1' }
        let(:no_of_building_occupants) { 192 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 16608.84
        end
      end

      context 'when service is G.2' do
        let(:code) { 'G.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 344.27
        end
      end

      context 'when service is G.3' do
        let(:code) { 'G.3' }
        let(:no_of_building_occupants) { 192 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 25071.50
        end
      end

      context 'when service is G.4' do
        let(:code) { 'G.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2226.46
        end
      end

      context 'when service is G.6' do
        let(:code) { 'G.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 371.03
        end
      end

      context 'when service is G.7' do
        let(:code) { 'G.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 683.33
        end
      end

      context 'when service is G.15' do
        let(:code) { 'G.15' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 480.16
        end
      end

      context 'when service is G.5' do
        let(:code) { 'G.5' }
        let(:size_of_external_area) { 925 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2986.90
        end
      end

      context 'when service is G.9' do
        let(:code) { 'G.9' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 273.69
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 869.97
        end
      end

      context 'when service is G.11' do
        let(:code) { 'G.11' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 56.35
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 197.42
        end
      end

      context 'when service is G.16' do
        let(:code) { 'G.16' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1976.78
        end
      end

      context 'when service is H.4' do
        let(:code) { 'H.4' }
        # 1820 service hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 44670.77
        end
      end

      context 'when service is H.5' do
        let(:code) { 'H.5' }
        # 1820 service hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 36607.39
        end
      end

      context 'when service is H.7' do
        let(:code) { 'H.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 58.29
        end
      end

      context 'when service is H.1' do
        let(:code) { 'H.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1056.48
        end
      end

      context 'when service is H.2' do
        let(:code) { 'H.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 1379.88
        end
      end

      context 'when service is H.3' do
        let(:code) { 'H.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 149.14
        end
      end

      context 'when service is H.6' do
        let(:code) { 'H.6' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 712.87
        end
      end

      context 'when service is H.8' do
        let(:code) { 'H.8' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 9.17
        end
      end

      context 'when service is H.10' do
        let(:code) { 'H.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 119.43
        end
      end

      context 'when service is H.11' do
        let(:code) { 'H.11' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 657.39
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 3691.81
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
          expect(report.assessed_value.round(2)).to eq 31174.04
        end
      end

      context 'when service is I.2' do
        # 1820 service_hours
        let(:code) { 'I.2' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29728.88
        end
      end

      context 'when service is I.3' do
        # 1820 service_hours
        let(:code) { 'I.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29820.02
        end
      end

      context 'when service is I.4' do
        # 1820 service_hours
        let(:code) { 'I.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29947.17
        end
      end

      context 'when service is J.1' do
        let(:code) { 'J.1' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 28583.76
        end
      end

      context 'when service is J.2' do
        let(:code) { 'J.2' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29243.18
        end
      end

      context 'when service is J.3' do
        let(:code) { 'J.3' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29099.50
        end
      end

      context 'when service is J.4' do
        let(:code) { 'J.4' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 32716.98
        end
      end

      context 'when service is J.5' do
        let(:code) { 'J.5' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29350.83
        end
      end

      context 'when service is J.6' do
        let(:code) { 'J.6' }
        # 1820 service_hours

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 29108.19
        end
      end

      context 'when service is J.7' do
        let(:code) { 'J.7' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 91.13
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 939.71
        end
      end

      context 'when service is J.10' do
        let(:code) { 'J.10' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 371.87
        end
      end

      context 'when service is J.11' do
        let(:code) { 'J.11' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 499.34
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
          expect(report.assessed_value.round(2)).to eq 6099.89
        end
      end

      context 'when service is K.3' do
        let(:code) { 'K.3' }
        let(:tones_to_be_collected_and_removed) { 2 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 440.33
        end
      end

      context 'when service is K.1' do
        let(:code) { 'K.1' }
        let(:no_of_consoles_to_be_serviced) { 22 }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 2564.26
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

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 132.75
        end
      end

      context 'when service is L.3' do
        let(:code) { 'L.3' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5821.81
        end
      end

      context 'when service is L.4' do
        let(:code) { 'L.4' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 163.64
        end
      end

      context 'when service is L.5' do
        let(:code) { 'L.5' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 69.22
        end
      end
    end

    context 'when tupe is true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings, tupe: true)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5007.49
        end
      end
    end

    context 'when London location' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 5401.49
        end
      end
    end

    context 'when CAFM true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
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
          expect(report.assessed_value.round(2)).to eq 4612.38
        end
      end
    end

    context 'when Helpdesk true' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
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
          expect(report.assessed_value.round(2)).to eq 4682.00
        end
      end
    end

    context 'when estimated value is known' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings,
                                                                estimated_cost_known: true,
                                                                estimated_annual_cost: 5500)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 4864.18
        end
      end
    end

    context 'when procurement initial call of period is for 2 years' do
      let(:code) { nil }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: code,
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings, initial_call_off_period: 2)))
      end

      context 'when service is C.1' do
        let(:code) { 'C.1' }

        it 'returns the right assessed value' do
          expect(report.assessed_value.round(2)).to eq 8987.29
        end
      end
    end

    context 'when multiple buildings' do
      let(:service_hours) { { "monday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "tuesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "wednesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "thursday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "friday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "saturday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "sunday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "uom": 0 } }
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'C.11',
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
        expect(report.assessed_value.round(2)).to eq 29938.65
      end
    end
  end

  describe '#selected_suppliers' do
    context 'when region is UKH1' do
      let(:procurement_building_service) do
        create(:facilities_management_procurement_building_service,
               code: 'C.1',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:supplier_name) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service.procurement_building.building.building_json['address']['fm-address-region-code']] - l['regions']).empty? &&
              ([procurement_building_service.code] - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_region) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service.procurement_building.building.building_json['address']['fm-address-region-code']] - l['regions']).any? &&
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
              ([procurement_building_service.procurement_building.building.building_json['address']['fm-address-region-code']] - l['regions']).empty? &&
              ([procurement_building_service.code] - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_service) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service.procurement_building.building.building_json['address']['fm-address-region-code']] - l['regions']).empty? &&
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
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:procurement_building_service_c2) do
        create(:facilities_management_procurement_building_service,
               code: 'C.2',
               procurement_building: procurement_building_service_c1.procurement_building)
      end
      let(:procurement_building_service_c3) do
        create(:facilities_management_procurement_building_service,
               code: 'C.3',
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
              ([procurement_building_service_c1.procurement_building.building.building_json['address']['fm-address-region-code']] - l['regions']).empty? &&
              (procurement.procurement_building_services.map(&:code) - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_service) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              ([procurement_building_service_c1.procurement_building.building.building_json['address']['fm-address-region-code']] - l['regions']).empty? &&
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
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end
      let(:procurement_building_service_c6) do
        create(:facilities_management_procurement_building_service,
               code: 'C.6',
               procurement_building: create(:facilities_management_procurement_building_no_services,
                                            building_id: create(:facilities_management_building_london).id,
                                            procurement: create(:facilities_management_procurement_no_procurement_buildings)))
      end

      let(:procurement) { procurement_building_service_c6.procurement_building.procurement }
      let(:supplier_name) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              (procurement.procurement_buildings.map { |pb| pb.building.building_json['address']['fm-address-region-code'] } - l['regions']).empty? &&
              (procurement.procurement_building_services.map(&:code) - l['services']).empty?
          end
        end.first.data['supplier_name']
      end

      let(:supplier_name_no_service) do
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == '1a') &&
              (procurement.procurement_building_services.map { |pb| pb.procurement_building.building.building_json['address']['fm-address-region-code'] } - l['regions']).any? &&
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
  end
end
