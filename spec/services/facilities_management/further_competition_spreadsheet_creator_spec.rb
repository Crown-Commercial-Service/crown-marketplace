require 'rails_helper'

RSpec.describe FacilitiesManagement::FurtherCompetitionSpreadsheetCreator do
  let(:procurement_with_buildings) { create(:facilities_management_procurement_with_contact_details_with_buildings) }
  let(:spreadsheet_builder) { described_class.new(procurement_with_buildings.id) }

  context 'and verify FX excel' do
    before do
      spreadsheet = spreadsheet_builder.build

      IO.write('/tmp/further_competition_procurement_summary.xlsx', spreadsheet.to_stream.read)
    end

    it 'verify address formatting' do
      user = procurement_with_buildings.user
      expect(spreadsheet_builder.get_address(procurement_with_buildings.user.buyer_detail)).to eq(user.buyer_detail.organisation_address_line_1 + ', ' +
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
      rows_found = false if wb.sheet('Buildings information').last_row == 0
      rows_found = false if wb.sheet('Customer & Contract Details').last_row == 0
      expect(rows_found).to be true
    end

    it 'verify service matrix worksheet' do
      wb = Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')

      expect(wb.sheet('Service Matrix').row(2)).to eq ['C.1', 'Mechanical and electrical engineering maintenance - Standard A', 'Yes', 'Yes']
    end
  end
end
