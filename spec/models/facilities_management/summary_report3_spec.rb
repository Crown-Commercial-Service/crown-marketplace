require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  include ActionView::Helpers::NumberHelper

  let(:user) { create(:user, :without_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }
  let(:supplier_names) do
    [:"Wolf-Wiza",
     :"Bogan-Koch",
     :"O'Keefe LLC",
     :"Treutel LLC",
     :"Hirthe-Mills",
     :"Kemmer Group",
     :"Mayer-Russel",
     :"Bode and Sons",
     :"Collier Group",
     :"Hickle-Schinner",
     :"Leffler-Strosin",
     :"Dickinson-Abbott",
     :"O'Keefe-Mitchell",
     :"Schmeler-Leuschke",
     :"Abernathy and Sons",
     :"Cartwright and Sons",
     :"Dare, Heaney and Kozey",
     :"Rowe, Hessel and Heller",
     :"Kulas, Schultz and Moore",
     :"Walsh, Murphy and Gaylord",
     :"Shields, Ratke and Parisian",
     :"Ullrich, Ratke and Botsford",
     :"Lebsack, Vandervort and Veum",
     :"Marvin, Kunde and Cartwright",
     :"Kunze, Langworth and Parisian",
     :"Halvorson, Corwin and O'Connell"]
  end

  context 'and dummy buildings to a db', skip: true do
    let(:services_data) do
      [
        { 'code' => 'J.8', 'name' => 'Additional security services' },
        { 'code' => 'H.16', 'name' => 'Administrative support services' },
        { 'code' => 'C.21', 'name' => 'Airport and aerodrome maintenance services' },
        { 'code' => 'H.9', 'name' => 'Archiving (on-site)' },
        { 'code' => 'E.1', 'name' => 'Asbestos management' },
        { 'code' => 'C.15', 'name' => 'Audio visual (AV) equipment maintenance' },
        { 'code' => 'C.10', 'name' => 'Automated barrier control system maintenance' },
        { 'code' => 'E.9', 'name' => 'Building information modelling and government soft landings' },
        { 'code' => 'C.11', 'name' => 'Building management system (BMS) maintenance' },
        { 'code' => 'H.12', 'name' => 'Cable management' },
        { 'code' => 'M.1', 'name' => 'CAFM system' },
        { 'code' => 'I.3', 'name' => 'Car park management and booking' },
        { 'code' => 'C.14', 'name' => 'Catering equipment maintenance' },
        { 'code' => 'J.2', 'name' => 'CCTV / alarm monitoring' },
        { 'code' => 'L.1', 'name' => 'Childcare facility' },
        { 'code' => 'F.1', 'name' => 'Chilled potable water' },
        { 'code' => 'K.1', 'name' => 'Classified waste' },
        { 'code' => 'G.8', 'name' => 'Cleaning of communications and equipment rooms' },
        { 'code' => 'G.13', 'name' => 'Cleaning of curtains and window blinds' },
        { 'code' => 'G.5', 'name' => 'Cleaning of external areas' },
        { 'code' => 'G.2', 'name' => 'Cleaning of integral barrier mats' },
        { 'code' => 'K.5', 'name' => 'Clinical waste' },
        { 'code' => 'H.7', 'name' => 'Clocks' },
        { 'code' => 'E.5', 'name' => 'Compliance plans, specialist surveys and audits' },
        { 'code' => 'E.6', 'name' => 'Conditions survey' },
        { 'code' => 'J.3', 'name' => 'Control of access and security passes' },
        { 'code' => 'H.3', 'name' => 'Courier booking and external distribution' },
        { 'code' => 'D.6', 'name' => 'Cut flowers and christmas trees' },
        { 'code' => 'G.4', 'name' => 'Deep (periodic) cleaning' },
        { 'code' => 'F.3', 'name' => 'Deli/coffee bar' },
        { 'code' => 'L.3', 'name' => 'Driver and vehicle service' },
        { 'code' => 'E.7', 'name' => 'Electrical testing' },
        { 'code' => 'J.4', 'name' => 'Emergency response' },
        { 'code' => 'J.9', 'name' => 'Enhanced security requirements' },
        { 'code' => 'C.3', 'name' => 'Environmental cleaning service' },
        { 'code' => 'F.4', 'name' => 'Events and functions' },
        { 'code' => 'K.7', 'name' => 'Feminine hygiene waste' },
        { 'code' => 'C.4', 'name' => 'Fire detection and firefighting systems maintenance' },
        { 'code' => 'E.8', 'name' => 'Fire risk assessments' },
        { 'code' => 'L.4', 'name' => 'First aid and medical service' },
        { 'code' => 'L.5', 'name' => 'Flag flying service' },
        { 'code' => 'L.8', 'name' => 'Footwear cobbling services' },
        { 'code' => 'F.5', 'name' => 'Full service restaurant' },
        { 'code' => 'H.10', 'name' => 'Furniture management' },
        { 'code' => 'K.2', 'name' => 'General waste' },
        { 'code' => 'D.1', 'name' => 'Grounds maintenance services' },
        { 'code' => 'L.7', 'name' => 'Hairdressing services' },
        { 'code' => 'H.4', 'name' => 'Handyman services' },
        { 'code' => 'K.4', 'name' => 'Hazardous waste' },
        { 'code' => 'N.1', 'name' => 'Helpdesk services' },
        { 'code' => 'C.13', 'name' => 'High voltage (HV) and switchgear maintenance' },
        { 'code' => 'F.6', 'name' => 'Hospitality and meetings' },
        { 'code' => 'G.10', 'name' => 'Housekeeping' },
        { 'code' => 'L.10', 'name' => 'Housing and residential accommodation management' },
        { 'code' => 'C.7', 'name' => 'Internal and external building fabric maintenance' },
        { 'code' => 'H.2', 'name' => 'Internal messenger service' },
        { 'code' => 'D.5', 'name' => 'Internal planting' },
        { 'code' => 'G.11', 'name' => 'It equipment cleaning' },
        { 'code' => 'L.6', 'name' => 'Journal, magazine and newspaper supply' },
        { 'code' => 'J.10', 'name' => 'Key holding' },
        { 'code' => 'C.5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
        { 'code' => 'G.16', 'name' => 'Linen and laundry services' },
        { 'code' => 'J.11', 'name' => 'Lock up / open up of buyer premises' },
        { 'code' => 'C.20', 'name' => 'Locksmith services' },
        { 'code' => 'C.17', 'name' => 'Mail room equipment maintenance' },
        { 'code' => 'H.1', 'name' => 'Mail services' },
        { 'code' => 'J.6', 'name' => 'Management of visitors and passes' },
        { 'code' => 'J.1', 'name' => 'Manned guarding service' },
        { 'code' => 'C.1', 'name' => 'Mechanical and electrical engineering maintenance' },
        { 'code' => 'G.14', 'name' => 'Medical and clinical cleaning' },
        { 'code' => 'K.6', 'name' => 'Medical waste' },
        { 'code' => 'G.3', 'name' => 'Mobile cleaning services' },
        { 'code' => 'H.5', 'name' => 'Move and space management . internal moves' },
        { 'code' => 'C.18', 'name' => 'Office machinery servicing and maintenance' },
        { 'code' => 'F.7', 'name' => 'Outside catering' },
        { 'code' => 'J.5', 'name' => 'Patrols (fixed or static guarding)' },
        { 'code' => 'J.12', 'name' => 'Patrols (mobile via a specific visiting vehicle)' },
        { 'code' => 'G.15', 'name' => 'Pest control services' },
        { 'code' => 'C.9', 'name' => 'Planned / group re.lamping service' },
        { 'code' => 'E.4', 'name' => 'Portable appliance testing' },
        { 'code' => 'H.15', 'name' => 'Portable washroom solutions' },
        { 'code' => 'H.6', 'name' => 'Porterage' },
        { 'code' => 'D.3', 'name' => 'Professional snow & ice clearance' },
        { 'code' => 'L.9', 'name' => 'Provision of chaplaincy support services' },
        { 'code' => 'G.9', 'name' => 'Reactive cleaning (outside cleaning operational hours)' },
        { 'code' => 'J.7', 'name' => 'Reactive guarding' },
        { 'code' => 'C.8', 'name' => 'Reactive maintenance services' },
        { 'code' => 'I.1', 'name' => 'Reception service' },
        { 'code' => 'K.3', 'name' => 'Recycled waste' },
        { 'code' => 'H.13', 'name' => 'Reprographics service' },
        { 'code' => 'D.4', 'name' => 'Reservoirs, ponds, river walls and water features maintenance' },
        { 'code' => 'F.10', 'name' => 'Residential catering services' },
        { 'code' => 'F.2', 'name' => 'Retail services / convenience store' },
        { 'code' => 'G.1', 'name' => 'Routine cleaning' },
        { 'code' => 'C.6', 'name' => 'Security, access and intruder systems maintenance' },
        { 'code' => 'H.8', 'name' => 'Signage' },
        { 'code' => 'H.11', 'name' => 'Space management' },
        { 'code' => 'G.12', 'name' => 'Specialist cleaning' },
        { 'code' => 'C.22', 'name' => 'Specialist maintenance services' },
        { 'code' => 'L.2', 'name' => 'Sports and leisure' },
        { 'code' => 'C.12', 'name' => 'Standby power system maintenance' },
        { 'code' => 'E.3', 'name' => 'Statutory inspections' },
        { 'code' => 'H.14', 'name' => 'Stores management' },
        { 'code' => 'I.2', 'name' => 'Taxi booking service' },
        { 'code' => 'C.16', 'name' => 'Television cabling maintenance' },
        { 'code' => 'L.11', 'name' => 'Training establishment management and booking service' },
        { 'code' => 'D.2', 'name' => 'Tree surgery (arboriculture)' },
        { 'code' => 'F.8', 'name' => 'Trolley service' },
        { 'code' => 'F.9', 'name' => 'Vending services (food & beverage)' },
        { 'code' => 'C.2', 'name' => 'Ventilation and air conditioning system maintenance' },
        { 'code' => 'C.19', 'name' => 'Voice announcement system maintenance' },
        { 'code' => 'I.4', 'name' => 'Voice announcement system operation' },
        { 'code' => 'E.2', 'name' => 'Water hygiene maintenance' },
        { 'code' => 'G.7', 'name' => 'Window cleaning (external)' },
        { 'code' => 'G.6', 'name' => 'Window cleaning (internal)' }
      ]
    end
    let(:lift_data) { %w[5 5 2 2] }
    let(:no_of_appliances_for_testing) { 230 }
    let(:no_of_building_occupants) { 678 }
    let(:size_of_external_area) { 125 }
    let(:no_of_consoles_to_be_serviced) { 100 }
    let(:tones_to_be_collected_and_removed) { 23 }
    let(:no_of_units_to_be_serviced) { 200 }
    let(:service_hours) { { "monday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "tuesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "wednesday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "thursday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "friday": { "service_choice": 'hourly', "start_hour": 10, "start_minute": 0, "start_ampm": 'AM', "end_hour": 5, "end_minute": 0, "end_ampm": 'PM', "uom": 7.0 }, "saturday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "sunday": { "service_choice": 'not_required', "start_hour": '', "start_minute": '', "start_ampm": 'AM', "end_hour": '', "end_minute": '', "end_ampm": 'AM', "uom": 0.0 }, "uom": 0 } }
    let(:procurement_building) { build(:facilities_management_procurement_building, active: false, procurement_building_services: [], building: build(:facilities_management_building)) }
    let(:procurement_building_london) { build(:facilities_management_procurement_building, active: true, procurement_building_services: [], building: build(:facilities_management_building_london)) }
    let(:procurement) { create(:facilities_management_procurement, initial_call_off_period: 7, procurement_buildings: [procurement_building, procurement_building_london]) }

    before do
      services_data.each do |service|
        procurement.active_procurement_buildings.each do |building|
          next unless service['code']

          create(:facilities_management_procurement_building_service,
                 code: service['code'],
                 procurement_building: building,
                 lift_data: lift_data,
                 no_of_appliances_for_testing: no_of_appliances_for_testing,
                 no_of_building_occupants: no_of_building_occupants,
                 size_of_external_area: size_of_external_area,
                 no_of_consoles_to_be_serviced: no_of_consoles_to_be_serviced,
                 tones_to_be_collected_and_removed: tones_to_be_collected_and_removed,
                 no_of_units_to_be_serviced: no_of_units_to_be_serviced,
                 service_hours: service_hours,
                 service_standard: 'A')
        end
      end
      procurement.set_state_to_results_if_possible
    end

    # rubocop:disable RSpec/ExampleLength
    it 'create a direct-award report check service price cell position' do
      # facilities_management_building_london building gia is 1002
      spreadsheet = FacilitiesManagement::DirectAwardSpreadsheet.new procurement.id

      IO.write('/tmp/direct_award_prices_3.xlsx', spreadsheet.to_xlsx)

      # one building does not contain K.7, verify service cells are in correct position
      wb = Roo::Excelx.new('/tmp/direct_award_prices_3.xlsx')
      # wb.sheet('Contract Price Matrix').row(24)[0]).to eq 'K.7'
      expect(wb.sheet('Contract Price Matrix').row(24)[2]).to eq 190.38
      expect(wb.sheet('Contract Price Matrix').row(24)[3]).to eq nil
      expect(wb.sheet('Contract Price Matrix').row(24)[4]).to eq 190.38
    end

    it 'create a direct-award report check prices' do
      spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new procurement.id
      spreadsheet = spreadsheet_builder.build
      # render xlsx: spreadsheet.to_stream.read, filename: 'deliverable_matrix', format: # 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
      IO.write('/tmp/deliverable_matrix_3.xlsx', spreadsheet.to_stream.read)
    end

    it 'create a direct-award report with contract length of 1 year' do
      spreadsheet = FacilitiesManagement::DirectAwardSpreadsheet.new procurement.id

      IO.write('/tmp/direct_award_prices_3_1year.xlsx', spreadsheet.to_xlsx)

      spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new procurement.id
      spreadsheet = spreadsheet_builder.build

      # render xlsx: spreadsheet.to_stream.read, filename: 'deliverable_matrix', format: # 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
      IO.write('/tmp/deliverable_matrix_3_1year.xlsx', spreadsheet.to_stream.read)
    end

    it 'create a direct-award report, verify only allowed volume worksheet services are displayed' do
      spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new procurement.id
      spreadsheet = spreadsheet_builder.build

      IO.write('/tmp/deliverable_matrix_3_1year.xlsx', spreadsheet.to_stream.read)

      wb = Roo::Excelx.new('/tmp/deliverable_matrix_3_1year.xlsx')
      number_rows = wb.sheet('Volume').last_row

      allowed_services = spreadsheet_builder.list_of_allowed_volume_services
      not_allowed = false

      (2..number_rows).each do |row_number|
        not_allowed = true unless allowed_services.include? wb.sheet('Volume').row(row_number)[0]
      end

      expect(number_rows).to be > 1
      expect(not_allowed).to eq false
    end

    it 'create a direct-award report with contract length of 1 year and verify a report for each building' do
      report_results = {}
      supplier_names.each do |supplier_name|
        report.calculate_services_for_buildings supplier_name
        report_results[supplier_name] = report.results
      end

      buildings_ids = procurement.procurement_buildings.map(&:building_id).flatten.uniq
      supplier_names.each do |supplier_name|
        # verify a report is generated for each building
        buildings_ids.each do |building_id|
          expect(report_results[supplier_name][building_id].count).to be > 0
        end
      end
    end

    it 'can calculate a direct award procurement' do
      report = described_class.new(procurement.id)
      supplier_names.each do |supplier_name|
        report.calculate_services_for_buildings supplier_name
        expect(report.direct_award_value).to be > -1
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
