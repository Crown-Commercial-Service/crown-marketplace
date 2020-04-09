require 'rails_helper'

RSpec.describe FacilitiesManagement::FurtherCompetitionSpreadsheetCreator do
  let(:user) { create(:user, buyer_detail: build(:buyer_detail)) }
  let(:code) { 'C.5' }
  let(:code1) { 'I.3' }
  let(:code2) { 'K.3' }
  let(:code3) { 'M.1' }
  let(:lift_data) { nil }
  let(:initial_call_off_period) { 7 }
  let(:estimated_annual_cost) { 7000000 }
  # building #1
  let(:procurement_building_service) do
    create(:facilities_management_procurement_building_service,
           code: code,
           service_standard: 'A',
           lift_data: %w[1000 1000 1000 1000],
           procurement_building: create(:facilities_management_procurement_building_no_services,
                                        building_id: create(:facilities_management_building_london).id,
                                        created_at: Time.zone.now,
                                        procurement: create(:facilities_management_procurement_no_procurement_buildings,
                                                            initial_call_off_period: initial_call_off_period,
                                                            estimated_annual_cost: estimated_annual_cost,
                                                            user: user,
                                                            initial_call_off_start_date: Time.zone.now + 2.months,
                                                            estimated_cost_known: true)))
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
  let(:procurement_building_service_3) do
    create(:facilities_management_procurement_building_service,
           code: code3,
           procurement_building: procurement_building_service_2.procurement_building)
  end

  # building #2
  let(:procurement_building_service_b2) do
    create(:facilities_management_procurement_building_service,
           code: code,
           service_standard: 'A',
           lift_data: %w[1000 1000 1000 1000],
           procurement_building: create(:facilities_management_procurement_building_no_services,
                                        created_at: Time.zone.now - 1.hour,
                                        building_id: create(:facilities_management_building).id,
                                        procurement: procurement_building_service_3.procurement_building.procurement))
  end
  let(:procurement_building_service_b2_1) do
    create(:facilities_management_procurement_building_service,
           code: code1,
           procurement_building: procurement_building_service_b2.procurement_building)
  end
  let(:procurement) { procurement_building_service_b2_1.procurement_building.procurement }

  let(:spreadsheet_builder) { described_class.new(procurement.id) }

  context 'and add dummy buildings to a db' do
    before do
      spreadsheet = spreadsheet_builder.build

      IO.write('/tmp/further_competition_procurement_summary.xlsx', spreadsheet.to_stream.read)
    end

    it 'verify address formatting' do
      expect(spreadsheet_builder.get_address(user.buyer_detail)).to eq(user.buyer_detail.organisation_address_line_1 + ', ' +
                                                                      user.buyer_detail.organisation_address_line_2 + ', ' +
                                                                      user.buyer_detail.organisation_address_town + ', ' +
                                                                      user.buyer_detail.organisation_address_county + '. ' +
                                                                      user.buyer_detail.organisation_address_postcode)
    end

    it 'verify worksheets are present' do
      wb = Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')
      rows_found = true
      rows_found = false if wb.sheet('Service Matrix').last_row == 0
      rows_found = false if wb.sheet('Volume').last_row == 0
      rows_found = false if wb.sheet('Service Periods').last_row == 0
      rows_found = false if wb.sheet('Shortlist').last_row == 0
      expect(rows_found).to be true
    end

    it 'verify service matrix worksheet' do
      pb1 = procurement.active_procurement_buildings.first
      pb2 = procurement.active_procurement_buildings.last
      wb = Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')
      expect(wb.sheet('Service Matrix').row(2)).to eq ['C.5', 'Lifts, hoists & conveyance systems maintenance - Standard A', 'Yes', 'Yes']
      expect(wb.sheet('Service Matrix').row(4)).to eq ['K.3', 'Recycled waste', pb1.procurement_building_services.where(code: 'K.3').any? ? 'Yes' : nil, pb2.procurement_building_services.where(code: 'K.3').any? ? 'Yes' : nil]
      expect(wb.sheet('Service Matrix').row(5)).to eq ['M.1', 'CAFM system', pb1.procurement_building_services.where(code: 'M.1').any? ? 'Yes' : nil, pb2.procurement_building_services.where(code: 'M.1').any? ? 'Yes' : nil]
    end
  end
end
