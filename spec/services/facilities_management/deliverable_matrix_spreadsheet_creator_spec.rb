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

  let(:building1_json) do
    {
      'id' => 'd92b0939-d7c4-0d54-38dd-a2a2709cb95b',
      'gia' => 4200,
      'name' => 'c4',
      'region' => 'London',
      'description' => 'Channel 4',
      'address' => {
        'fm-address-town' => 'London',
        'fm-address-line-1' => '1 Horseferry Road',
        'fm-address-postcode' => 'SW1P 2BA',
        'fm-address-region' => 'Outer London - South'
      },
      'isLondon' => false,
      :'security-type' => 'Baseline Personnel Security Standard',
      'services' => [
        { 'code' => 'M-1', 'name' => 'CAFM system' },
        { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
        { 'code' => 'I-1', 'name' => 'Reception service' },
        { 'code' => 'K-3', 'name' => 'Recycled waste' }
      ],
      :'fm-building-type' => 'General office - Customer Facing',
      'building-type' => 'General office - Customer Facing'
    }
  end

  let(:building2_json) do
    {
      'id' => 'e60f5b57-5f15-604c-b729-a689ede34a99',
      'gia' => 12000,
      'name' => 'ccs',
      'region' => 'London',
      'description' => 'Crown Commercial Service',
      'address' => {
        'fm-address-town' => 'London',
        'fm-address-line-1' => '151 Buckingham Palace Road',
        'fm-address-postcode' => 'SW1W 9SZ',
        'fm-address-region' => 'Outer London - South'
      },
      'isLondon' => false,
      :'security-type' => 'Baseline Personnel Security Standard',
      'services' => [
        { 'code' => 'M-1', 'name' => 'CAFM system' },
        { 'code' => 'C-5', 'name' => 'Lifts, hoists and conveyance systems maintenance' },
        { 'code' => 'I-1', 'name' => 'Reception service' },
        { 'code' => 'K-3', 'name' => 'Recycled waste' }
      ],
      :'fm-building-type' => 'Warehouse',
      'building-type' => 'Warehouse'
    }
  end

  before do
    create(:ccs_fm_rate_card)

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

    procurement.active_procurement_buildings.first.building.update(building_json: building1_json)
    procurement.active_procurement_buildings.last.building.update(building_json: building2_json)
  end

  it 'verify for, service periods worksheet, worksheet headers' do
    expect(wb.sheet('Service Periods').row(1)).to match_array(['Service Reference', 'Service Name', 'Specific Service Periods', 'Building 1', 'Building 2'])
    expect(wb.sheet('Service Periods').row(2)).to match_array(['I.1', 'Reception service', 'Monday', 'Not required', 'Not required'])
    expect(wb.sheet('Service Periods').row(4)).to match_array(['I.1', 'Reception service', 'Wednesday', '08:00am to 05:30pm', '08:00am to 05:30pm'])
  end

  it 'verify for, Building Information, worksheet the NUTS region' do
    expect(wb.sheet('Buildings information').row(1)).to match_array(['Buildings information', 'Building 1', 'Building 2'])
    expect(wb.sheet('Buildings information').row(7)).to match_array(['Building Location (NUTS Region)', 'Outer London - South', 'Outer London - South'])
  end
end
