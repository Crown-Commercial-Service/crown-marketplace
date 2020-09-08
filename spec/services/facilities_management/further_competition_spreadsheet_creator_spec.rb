require 'rails_helper'

RSpec.describe FacilitiesManagement::FurtherCompetitionSpreadsheetCreator do
  let(:procurement_with_buildings) { create(:facilities_management_procurement_for_further_competition_with_gia) }
  let(:spreadsheet_builder) { described_class.new(procurement_with_buildings.id) }

  context 'and verify FC excel' do
    let(:wb) do
      first_building = procurement_with_buildings.active_procurement_buildings.first
      create(:facilities_management_procurement_building_service_with_service_hours, procurement_building: first_building)
      report = FacilitiesManagement::SummaryReport.new(procurement_with_buildings.id)

      supplier_names = CCS::FM::RateCard.latest.data[:Prices].keys
      supplier_names.each do |supplier_name|
        report.calculate_services_for_buildings(supplier_name, true, :fc)
      end
      spreadsheet = spreadsheet_builder.build
      IO.write('/tmp/further_competition_procurement_summary.xlsx', spreadsheet.to_stream.read)
      Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')
    end

    it 'verify address formatting' do
      user = procurement_with_buildings.user
      expect(spreadsheet_builder.get_address(procurement_with_buildings.user.buyer_detail)).to eq(user.buyer_detail.organisation_address_line_1 + ', ' +
                                                                      user.buyer_detail.organisation_address_line_2 + ', ' +
                                                                      user.buyer_detail.organisation_address_town + ', ' +
                                                                      user.buyer_detail.organisation_address_county + '. ' +
                                                                      user.buyer_detail.organisation_address_postcode)
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

    # rubocop:disable RSpec/MultipleExpectations
    it 'Verify Service Periods headers' do
      expect(wb.sheet('Service Periods').row(1)).to eq ['Service Reference', 'Service Name', 'Metric per Annum', 'Building 1']
      expect(wb.sheet('Service Periods').row(2)).to eq [nil, nil, nil, 'asa']
      expect(wb.sheet('Service Periods').row(3)).to eq ['H.4', 'Handyman services', 'Number of hours required', 208]
      expect(wb.sheet('Service Periods').row(4)).to eq ['H.4', 'Handyman services', 'Detail of requirement', 'Details of the requirement']
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'Verify Shortlist headers' do
      procurement_with_buildings.procurement_buildings.each(&:set_gia)
      expect(wb.sheet('Shortlist').row(1)).to eq ['Reference number:', nil]
      expect(wb.sheet('Shortlist').row(2)).to eq ['Date/time production of this document:', nil]
      expect(wb.sheet('Shortlist').row(4)).to eq ['Cost and sub-lot recommendation', nil]
      expect(wb.sheet('Shortlist').row(5)).to eq ['Estimated cost', '£11,541.72 ']
      expect(wb.sheet('Shortlist').row(6)).to eq ['Sub-lot recommendation', 'Sub-lot 1a']
      expect(wb.sheet('Shortlist').row(7)).to eq ['Sub-lot value range', 'Up to £7m']
      expect(wb.sheet('Shortlist').row(9)).to eq ['Suppliers shortlist', 'Further supplier information and contact details can be found here:']
      expect(wb.sheet('Shortlist').row(10)).to eq ['Abernathy and Sons', 'https://www.crowncommercial.gov.uk/agreements/RM3830/suppliers']
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'Verify Buildings information headers' do
      expect(wb.sheet('Buildings information').row(1)).to match_array(['Buildings information', 'Building 1'])
      expect(wb.sheet('Buildings information').row(2)).to match_array(['Building name', 'asa'])
      expect(wb.sheet('Buildings information').row(4)).to match_array(['Building Address - Line 1', '10 Mariners Court'])
      expect(wb.sheet('Buildings information').row(5)).to match_array(['Building Address - Line 2', 'Floor 2'])
      expect(wb.sheet('Buildings information').row(9)).to match_array(['Building Gross Internal Area (GIA) (sqm)', 1002])
      expect(wb.sheet('Buildings information').row(10)).to match_array(['Building External Area (sqm)', 4596])
      expect(wb.sheet('Buildings information').row(11)).to match_array(['Building Type', 'General office - Customer Facing'])
      expect(wb.sheet('Buildings information').row(12)).to match_array(['Building Type (other)', nil])
      expect(wb.sheet('Buildings information').row(13)).to match_array(['Building Security Clearance', 'Baseline personnel security standard (BPSS)'])
      expect(wb.sheet('Buildings information').row(14)).to match_array(['Building Security Clearance (other)', nil])
    end
    # rubocop:enable RSpec/MultipleExpectations

    it 'Verify Customer & Contract Details headers' do
      expect(wb.sheet('Customer & Contract Details').row(1)).to eq ['1. Customer details', nil]
      expect(wb.sheet('Customer & Contract Details').row(3)).to eq ['Buyer Organisation Name', 'MyString']
    end
  end
end
