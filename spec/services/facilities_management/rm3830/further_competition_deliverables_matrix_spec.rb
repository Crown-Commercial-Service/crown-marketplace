require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::FurtherCompetitionDeliverablesMatrix do
  let(:procurement_with_buildings) { create(:facilities_management_rm3830_procurement_for_further_competition_with_gia, assessed_value: 11541.72, lot_number: '1a') }
  let(:spreadsheet_builder) { described_class.new(procurement_with_buildings.id) }

  let(:supplier_ids) { FacilitiesManagement::RM3830::SupplierDetail.where(supplier_name: supplier_names).pluck(:supplier_id) }

  include_context 'with list of suppliers'

  before do
    procurement_with_buildings.active_procurement_buildings.first.update(service_codes: ['C.1', 'H.4'])
    procurement_with_buildings.active_procurement_buildings.first.procurement_building_services.find_by(code: 'C.1').update(service_standard: 'B')
    procurement_with_buildings.active_procurement_buildings.first.procurement_building_services.find_by(code: 'H.4').update(service_hours: 208, detail_of_requirement: 'Details of the requirement')
    procurement_with_buildings.procurement_suppliers.create(supplier_id: FacilitiesManagement::RM3830::SupplierDetail.find_by(supplier_name: 'Abernathy and Sons').id, direct_award_value: 123456)
  end

  context 'and verify FC excel' do
    let(:wb) do
      report = FacilitiesManagement::RM3830::SummaryReport.new(procurement_with_buildings.id)

      supplier_ids.each do |supplier_id|
        report.calculate_services_for_buildings(supplier_id, :fc)
      end
      spreadsheet = spreadsheet_builder.build
      File.write('/tmp/further_competition_procurement_summary.xlsx', spreadsheet.to_stream.read, binmode: true)
      Roo::Excelx.new('/tmp/further_competition_procurement_summary.xlsx')
    end

    it 'verify address formatting' do
      user = procurement_with_buildings.user
      expect(spreadsheet_builder.send(:get_address, procurement_with_buildings.user.buyer_detail)).to eq("#{user.buyer_detail.organisation_address_line_1}, #{user.buyer_detail.organisation_address_line_2}, #{user.buyer_detail.organisation_address_town}, #{user.buyer_detail.organisation_address_county}. #{user.buyer_detail.organisation_address_postcode}")
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'Verify Service Marix headers' do
      expect(wb.sheet('Service Matrix').row(1)).to eq ['Service Reference', 'Service Name', 'Building 1']
      expect(wb.sheet('Service Matrix').row(2)).to eq [nil, nil, 'asa']
      expect(wb.sheet('Service Matrix').row(3)).to eq ['C.1', 'Mechanical and electrical engineering maintenance - Standard B', 'Yes']
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
      procurement_with_buildings.procurement_buildings.each(&:freeze_building_data)
      expect(wb.sheet('Shortlist').row(1)).to eq ['Reference number:', nil, nil]
      expect(wb.sheet('Shortlist').row(2)).to eq ['Date/time production of this document:', nil, nil]
      expect(wb.sheet('Shortlist').row(4)).to eq ['Cost and sub-lot recommendation', nil, nil]
      expect(wb.sheet('Shortlist').row(5)).to eq ['Estimated cost', '£11,541.72 ', '(Partial estimated cost)']
      expect(wb.sheet('Shortlist').row(6)).to eq ['Sub-lot recommendation', 'Sub-lot 1a', '(Customer selected)']
      expect(wb.sheet('Shortlist').row(7)).to eq ['Sub-lot value range', 'Up to £7m', nil]
      expect(wb.sheet('Shortlist').row(9)).to eq ['Suppliers shortlist', 'Further supplier information and contact details can be found here:', nil]
      expect(wb.sheet('Shortlist').row(10)).to eq ['Abernathy and Sons', 'https://www.crowncommercial.gov.uk/agreements/RM3830/suppliers', nil]
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'Verify Buildings information headers' do
      expect(wb.sheet('Buildings information').row(1)).to match_array(['Buildings information', 'Building 1'])
      expect(wb.sheet('Buildings information').row(2)).to match_array(['Building name', 'asa'])
      expect(wb.sheet('Buildings information').row(3)).to match_array(['Building Description', 'london building'])
      expect(wb.sheet('Buildings information').row(4)).to match_array(['Building Address - Line 1', '100 New Barn Street'])
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
