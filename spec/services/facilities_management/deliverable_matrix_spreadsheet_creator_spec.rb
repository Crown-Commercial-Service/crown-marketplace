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

  let(:service_hours) { FacilitiesManagement::ServiceHours.new }
  let(:user) { create(:user, :with_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }
  let(:procurement) { create(:facilities_management_procurement_with_contact_details_with_buildings, user: user) }
  let(:supplier) { create(:ccs_fm_supplier) }
  let(:contract) { create(:facilities_management_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

  before do
    service_hours[:monday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:tuesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:wednesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '08', start_minute: '00', start_ampm: 'am', end_hour: '05', end_minute: '30', end_ampm: 'PM', uom: 0)
    service_hours[:thursday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:friday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:saturday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'pm', end_hour: '05', end_minute: '30', end_ampm: 'AM', uom: 0)
    service_hours[:sunday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required, uom: 0, start_hour: '', start_minute: '', start_ampm: 'AM', end_hour: '', end_minute: '', end_ampm: 'AM')
    service_hours[:personnel] = 1

    procurement.active_procurement_buildings.each do |pb|
      pb.procurement_building_services[0].update(code: 'I.1', service_hours: service_hours)
    end
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'verify for, service periods, worksheet headers' do
    expect(wb.sheet('Service Periods').row(1)).to match_array(['Service Reference', 'Service Name', 'Specific Service Periods', 'Building 1', 'Building 2'])
    expect(wb.sheet('Service Periods').row(2)).to match_array([nil, nil, nil, 'asa', 'asa'])
    expect(wb.sheet('Service Periods').row(3)).to match_array(['I.1', 'Reception service', 'Monday', 'Not required', 'Not required'])
    expect(wb.sheet('Service Periods').row(4)).to match_array(['I.1', 'Reception service', 'Tuesday', 'All day (24 hours)', 'All day (24 hours)'])
    expect(wb.sheet('Service Periods').row(5)).to match_array(['I.1', 'Reception service', 'Wednesday', '8:00am to 5:30pm', '8:00am to 5:30pm'])
  end
  # rubocop:enable RSpec/MultipleExpectations

  # rubocop:disable RSpec/MultipleExpectations
  it 'verify for, Building Information, worksheet the NUTS region' do
    expect(wb.sheet('Buildings information').row(1)).to match_array(['Buildings information', 'Building 1', 'Building 2'])
    expect(wb.sheet('Buildings information').row(2)).to match_array(['Building name', 'asa', 'asa'])
    expect(wb.sheet('Buildings information').row(4)).to match_array(['Building Address - Street', '10 Mariners Court', '10 Mariners Court'])
    expect(wb.sheet('Buildings information').row(8)).to match_array(['Building Gross Internal Area (GIA) (sqm)', 1002, 1002])
    expect(wb.sheet('Buildings information').row(9)).to match_array(['Building External Area (sqm)', 4596, 4596])
    expect(wb.sheet('Buildings information').row(10)).to match_array(['Building Type', 'General office - Customer Facing', 'General office - Customer Facing'])
  end
  # rubocop:enable RSpec/MultipleExpectations

  it 'verify for, service matrix, worksheet headers' do
    expect(wb.sheet('Service Matrix').row(1)).to match_array(['Service Reference', 'Service Name', 'Building 1', 'Building 2'])
    expect(wb.sheet('Service Matrix').row(2)).to match_array([nil, nil, 'asa', 'asa'])
    expect(wb.sheet('Service Matrix').row(3)).to match_array(['I.1', 'Reception service', nil, nil])
  end

  it 'verify for, Volume, worksheet headers' do
    expect(wb.sheet('Volume').row(1)).to match_array(['Service Reference', 'Service Name', 'Metric per annum', 'Building 1', 'Building 2'])
    expect(wb.sheet('Volume').row(2)).to match_array([nil, nil, nil, 'asa', 'asa'])
    expect(wb.sheet('Volume').row(3)).to match_array(['I.1', 'Reception service', 'Number of hours required', 3484.0, 3484.0])
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'verify for, Customer & Contract Details, worksheet headers' do
    expect(wb.sheet('Customer & Contract Details').row(1)).to match_array(['1. Customer details', nil])
    expect(wb.sheet('Customer & Contract Details').row(3)).to match_array(['Buyer Organisation Name', 'MyString'])
    expect(wb.sheet('Customer & Contract Details').row(4)).to match_array(['Buyer Organisation Sector', 'Central Government'])
    expect(wb.sheet('Customer & Contract Details').row(7)).to match_array(['Buyer Contact Email Address', 'test@example.com'])
    expect(wb.sheet('Customer & Contract Details').row(10)).to match_array(['2. Contract requirements', nil])
  end
  # rubocop:enable RSpec/MultipleExpectations

  # rubocop:disable RSpec/MultipleExpectations
  it 'verify for, service information, worksheet headers' do
    expect(wb.sheet('Service Information').row(1)).to match_array(['Work Package Ref', 'Service Reference', 'Work Package'])
    expect(wb.sheet('Service Information').row(2)).to match_array(['Work Package A - Contract Management', nil, 'Work Package A – Contract Management'])
    expect(wb.sheet('Service Information').row(3)).to match_array(['Work Package A - Contract Management', nil, nil])
    expect(wb.sheet('Service Information').row(4)).to match_array(['Work Package A - Contract Management', nil, '1.       Service A:1 - Integration'])
    expect(wb.sheet('Service Information').row(5)).to match_array(['Work Package A - Contract Management', nil, '1.1.    Service A:1 – Integration is Mandatory for Lot 1a-1c.'])
  end
  # rubocop:enable RSpec/MultipleExpectations
end
