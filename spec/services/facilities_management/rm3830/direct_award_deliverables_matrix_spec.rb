require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::DirectAwardDeliverablesMatrix do
  include ActionView::Helpers::NumberHelper

  subject(:wb) do
    spreadsheet_builder = described_class.new(contract.id)
    spreadsheet = spreadsheet_builder.build
    path = '/tmp/deliverable_matrix_3_1year.xlsx'
    File.write(path, spreadsheet.to_stream.read, binmode: true)
    Roo::Excelx.new(path)
  end

  let(:service_hours) { 3484 }
  let(:detail_of_requirement) { 'Details of the requirement' }
  let(:no_of_appliances_for_testing) { 506 }
  let(:user) { create(:user, :with_detail, email: 'test@example.com', id: 'dGFyaXEuaGFtaWRAY3Jvd25jb21tZXJjaWFsLmdvdi51aw==\n') }
  let(:procurement) { create(:facilities_management_rm3830_procurement_with_contact_details_with_buildings, user:) }
  let(:supplier) { create(:facilities_management_rm3830_supplier_detail) }
  let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

  before do
    procurement.active_procurement_buildings.first.procurement_building_services[0].update(code: 'I.1', service_hours: service_hours, detail_of_requirement: detail_of_requirement)
    procurement.active_procurement_buildings.last.procurement_building_services[0].update(code: 'E.4', no_of_appliances_for_testing: no_of_appliances_for_testing)

    procurement.active_procurement_buildings.each do |building|
      service_codes = building.procurement_building_services.map(&:code)

      building.update(service_codes:)
    end
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'verify for, service periods, worksheet headers' do
    expect(wb.sheet('Service Periods').row(1)).to contain_exactly('Service Reference', 'Service Name', 'Metric per Annum', 'Building 1', 'Building 2')
    expect(wb.sheet('Service Periods').row(2)).to contain_exactly(nil, nil, nil, 'asa', 'asa')
    expect(wb.sheet('Service Periods').row(3)).to contain_exactly('I.1', 'Reception service', 'Number of hours required', service_hours, nil)
    expect(wb.sheet('Service Periods').row(4)).to contain_exactly('I.1', 'Reception service', 'Detail of requirement', detail_of_requirement, nil)
  end

  it 'verify for, Building Information, worksheet the NUTS region' do
    expect(wb.sheet('Buildings information').row(1)).to contain_exactly('Buildings information', 'Building 1', 'Building 2')
    expect(wb.sheet('Buildings information').row(2)).to contain_exactly('Building name', 'asa', 'asa')
    expect(wb.sheet('Buildings information').row(4)).to contain_exactly('Building Address - Line 1', '17 Sailors road', '17 Sailors road')
    expect(wb.sheet('Buildings information').row(5)).to contain_exactly('Building Address - Line 2', 'Floor 2', 'Floor 2')
    expect(wb.sheet('Buildings information').row(9)).to contain_exactly('Building Gross Internal Area (GIA) (sqm)', 1002, 1002)
    expect(wb.sheet('Buildings information').row(10)).to contain_exactly('Building External Area (sqm)', 4596, 4596)
    expect(wb.sheet('Buildings information').row(11)).to contain_exactly('Building Type', 'General office - Customer Facing', 'General office - Customer Facing')
    expect(wb.sheet('Buildings information').row(12)).to contain_exactly('Building Type (other)', nil, nil)
    expect(wb.sheet('Buildings information').row(13)).to contain_exactly('Building Security Clearance', 'Baseline personnel security standard (BPSS)', 'Baseline personnel security standard (BPSS)')
    expect(wb.sheet('Buildings information').row(14)).to contain_exactly('Building Security Clearance (other)', nil, nil)
  end

  it 'verify for, service matrix, worksheet headers' do
    expect(wb.sheet('Service Matrix').row(1)).to contain_exactly('Service Reference', 'Service Name', 'Building 1', 'Building 2')
    expect(wb.sheet('Service Matrix').row(2)).to contain_exactly(nil, nil, 'asa', 'asa')
    expect(wb.sheet('Service Matrix').row(3)).to contain_exactly('E.4', 'Portable appliance testing', nil, 'Yes')
    expect(wb.sheet('Service Matrix').row(4)).to contain_exactly('I.1', 'Reception service', 'Yes', nil)
  end

  it 'verify for, Volume, worksheet headers' do
    expect(wb.sheet('Volume').row(1)).to contain_exactly('Service Reference', 'Service Name', 'Metric per annum', 'Building 1', 'Building 2')
    expect(wb.sheet('Volume').row(2)).to contain_exactly(nil, nil, nil, 'asa', 'asa')
    expect(wb.sheet('Volume').row(3)).to contain_exactly('E.4', 'Portable appliance testing', 'Number of appliances to be tested', nil, 506)
    expect(wb.sheet('Volume').row(4)).to contain_exactly('I.1', 'Reception service', 'Number of hours required', 3484.0, nil)
  end

  it 'verify for, Customer & Contract Details, worksheet headers' do
    expect(wb.sheet('Customer & Contract Details').row(1)).to contain_exactly('1. Customer details', nil)
    expect(wb.sheet('Customer & Contract Details').row(3)).to contain_exactly('Buyer Organisation Name', 'MyString')
    expect(wb.sheet('Customer & Contract Details').row(4)).to contain_exactly('Buyer Organisation Sector', 'Central Government')
    expect(wb.sheet('Customer & Contract Details').row(7)).to contain_exactly('Buyer Contact Email Address', 'test@example.com')
    expect(wb.sheet('Customer & Contract Details').row(10)).to contain_exactly('2. Contract requirements', nil)
  end

  it 'verify for, service information, worksheet headers' do
    expect(wb.sheet('Service Information').row(1)).to contain_exactly('Work Package Ref', 'Service Reference', 'Work Package')
    expect(wb.sheet('Service Information').row(2)).to contain_exactly('Work Package A - Contract Management', nil, 'Work Package A – Contract Management')
    expect(wb.sheet('Service Information').row(3)).to contain_exactly('Work Package A - Contract Management', nil, nil)
    expect(wb.sheet('Service Information').row(4)).to contain_exactly('Work Package A - Contract Management', nil, '1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Service A:1 - Integration')
    expect(wb.sheet('Service Information').row(5)).to contain_exactly('Work Package A - Contract Management', nil, '1.1.&nbsp;&nbsp;&nbsp; Service A:1 – Integration is Mandatory for Lot 1a-1c.')
  end

  context 'when contract is sent' do
    let(:contract) { create(:facilities_management_rm3830_procurement_supplier_da, procurement: procurement, supplier_id: supplier.id) }

    before do
      allow(FacilitiesManagement::GovNotifyNotification).to receive(:perform_async).and_return(nil)
      allow(FacilitiesManagement::RM3830::GenerateContractZip).to receive(:perform_in).and_return(nil)
      allow(FacilitiesManagement::RM3830::ChangeStateWorker).to receive(:perform_at).and_return(nil)
      allow(FacilitiesManagement::RM3830::ContractSentReminder).to receive(:perform_at).and_return(nil)
      contract.offer_to_supplier!
    end

    it 'returns the right Customer & Contract details header' do
      expect(wb.sheet('Customer & Contract Details').row(1)).to contain_exactly('Reference number:', contract.contract_number)
      expect(wb.sheet('Customer & Contract Details').cell(2, 1)).to match('Date/time of production of this document:')
      expect(wb.sheet('Customer & Contract Details').cell(2, 2)).not_to be_nil
    end
  end
  # rubocop:enable RSpec/MultipleExpectations
end
