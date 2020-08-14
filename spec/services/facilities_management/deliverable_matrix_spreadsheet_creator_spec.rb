require 'rails_helper'

RSpec.describe FacilitiesManagement::DeliverableMatrixSpreadsheetCreator do
  include ActionView::Helpers::NumberHelper

  subject(:wb) do
    spreadsheet_builder = described_class.new(contract.id)
    spreadsheet = spreadsheet_builder.build
    path = '/tmp/deliverable_matrix_3_1year.xlsx'
    IO.write(path, spreadsheet.to_stream.read)
    Roo::Excelx.new(path)
  end

  let(:service_hours) { 3484 }
  let(:detail_of_requirement) { 'Details of the requirement' }
  let(:no_of_appliances_for_testing) { 506 }
  let(:user) { create(:user, :with_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }
  let(:procurement) { create(:facilities_management_procurement_with_contact_details_with_buildings, user: user) }
  let(:supplier) { create(:ccs_fm_supplier) }
  let(:contract) { create(:facilities_management_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

  before do
    procurement.active_procurement_buildings.first.procurement_building_services[0].update(code: 'I.1', service_hours: service_hours, detail_of_requirement: detail_of_requirement)
    procurement.active_procurement_buildings.last.procurement_building_services[0].update(code: 'E.4', no_of_appliances_for_testing: no_of_appliances_for_testing)
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'verify for, service periods, worksheet headers' do
    expect(wb.sheet('Service Periods').row(1)).to match_array(['Service Reference', 'Service Name', 'Metric per Annum', 'Building 1', 'Building 2'])
    expect(wb.sheet('Service Periods').row(2)).to match_array([nil, nil, nil, 'asa', 'asa'])
    expect(wb.sheet('Service Periods').row(3)).to match_array(['I.1', 'Reception service', 'Number of hours required', service_hours, nil])
    expect(wb.sheet('Service Periods').row(4)).to match_array(['I.1', 'Reception service', 'Detail of requirement', detail_of_requirement, nil])
  end

  it 'verify for, Building Information, worksheet the NUTS region' do
    expect(wb.sheet('Buildings information').row(1)).to match_array(['Buildings information', 'Building 1', 'Building 2'])
    expect(wb.sheet('Buildings information').row(2)).to match_array(['Building name', 'asa', 'asa'])
    expect(wb.sheet('Buildings information').row(4)).to match_array(['Building Address - Street', '10 Mariners Court', '10 Mariners Court'])
    expect(wb.sheet('Buildings information').row(8)).to match_array(['Building Gross Internal Area (GIA) (sqm)', 1002, 1002])
    expect(wb.sheet('Buildings information').row(9)).to match_array(['Building External Area (sqm)', 4596, 4596])
    expect(wb.sheet('Buildings information').row(10)).to match_array(['Building Type', 'General office - Customer Facing', 'General office - Customer Facing'])
  end

  it 'verify for, service matrix, worksheet headers' do
    expect(wb.sheet('Service Matrix').row(1)).to match_array(['Service Reference', 'Service Name', 'Building 1', 'Building 2'])
    expect(wb.sheet('Service Matrix').row(2)).to match_array([nil, nil, 'asa', 'asa'])
    expect(wb.sheet('Service Matrix').row(3)).to match_array(['E.4', 'Portable appliance testing', nil, nil])
    expect(wb.sheet('Service Matrix').row(4)).to match_array(['I.1', 'Reception service', nil, nil])
  end

  it 'verify for, Volume, worksheet headers' do
    expect(wb.sheet('Volume').row(1)).to match_array(['Service Reference', 'Service Name', 'Metric per annum', 'Building 1', 'Building 2'])
    expect(wb.sheet('Volume').row(2)).to match_array([nil, nil, nil, 'asa', 'asa'])
    expect(wb.sheet('Volume').row(3)).to match_array(['E.4', 'Portable appliance testing', 'Number of appliances to be tested', nil, 506])
    expect(wb.sheet('Volume').row(4)).to match_array(['I.1', 'Reception service', 'Number of hours required', 3484.0, nil])
  end

  it 'verify for, Customer & Contract Details, worksheet headers' do
    expect(wb.sheet('Customer & Contract Details').row(1)).to match_array(['1. Customer details', nil])
    expect(wb.sheet('Customer & Contract Details').row(3)).to match_array(['Buyer Organisation Name', 'MyString'])
    expect(wb.sheet('Customer & Contract Details').row(4)).to match_array(['Buyer Organisation Sector', 'Central Government'])
    expect(wb.sheet('Customer & Contract Details').row(7)).to match_array(['Buyer Contact Email Address', 'test@example.com'])
    expect(wb.sheet('Customer & Contract Details').row(10)).to match_array(['2. Contract requirements', nil])
  end

  it 'verify for, service information, worksheet headers' do
    expect(wb.sheet('Service Information').row(1)).to match_array(['Work Package Ref', 'Service Reference', 'Work Package'])
    expect(wb.sheet('Service Information').row(2)).to match_array(['Work Package A - Contract Management', nil, 'Work Package A – Contract Management'])
    expect(wb.sheet('Service Information').row(3)).to match_array(['Work Package A - Contract Management', nil, nil])
    expect(wb.sheet('Service Information').row(4)).to match_array(['Work Package A - Contract Management', nil, '1.       Service A:1 - Integration'])
    expect(wb.sheet('Service Information').row(5)).to match_array(['Work Package A - Contract Management', nil, '1.1.    Service A:1 – Integration is Mandatory for Lot 1a-1c.'])
  end
  # rubocop:enable RSpec/MultipleExpectations
end
