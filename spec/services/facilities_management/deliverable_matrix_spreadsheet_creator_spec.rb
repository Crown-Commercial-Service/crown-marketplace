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

    procurement.active_procurement_buildings.each do |pb|
      pb.procurement_building_services[0].update(code: 'I.1', service_hours: service_hours)
    end
  end

  it 'verify for, service periods worksheet, worksheet headers' do
    expect(wb.sheet('Service Periods').row(1)).to match_array(['Service Reference', 'Service Name', 'Specific Service Periods', 'Building 1', 'Building 2'])
  end

  it 'verify for, Building Information, worksheet the NUTS region' do
    expect(wb.sheet('Buildings information').row(1)).to match_array(['Buildings information', 'Building 1', 'Building 2'])
  end
end
