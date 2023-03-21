require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierDataSnapshotGenerator do
  let(:user_1) { create(:user, email: 'reiner.braun@attackontitn.pa') }
  let(:user_2) { create(:user, email: 'bertholdt.hoover@attackontitn.pa') }
  let(:new_upload) { create(:facilities_management_rm6232_admin_upload, user: user_2) }
  let(:supplier_data_1) { FacilitiesManagement::RM6232::Admin::SupplierData.latest_data }
  let(:supplier_data_2) { FacilitiesManagement::RM6232::Admin::SupplierData.create(upload: new_upload, data: supplier_data_1.data, created_at: get_time(2022, 3, 8, 10, 0, 30)) }
  let(:supplier_1_id) { supplier_data_1.data.find { |data| data['supplier_name'] == 'Abshire, Schumm and Farrell' }['id'] }
  let(:supplier_2_id) { supplier_data_1.data.find { |data| data['supplier_name'] == 'Skiles LLC' }['id'] }

  def get_time(*time_array)
    Time.zone.local(*time_array).in_time_zone('London')
  end

  before do
    supplier_data_1.update(created_at: get_time(2022, 3, 4, 12, 55, 30))
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data, user: user_1, created_at: get_time(2022, 3, 5, 1, 11, 30), supplier_id: supplier_1_id, data: { 'lot_code' => '1a', 'attribute' => 'service_codes', 'added' => %w[F.12], 'removed' => [] })
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 6, 13, 26, 30), supplier_id: supplier_1_id)
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_region_lot_data, user: user_1, created_at: get_time(2022, 3, 7, 4, 59, 30), supplier_id: supplier_2_id)
    supplier_data_2
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 9, 12, 0, 30), supplier_id: supplier_1_id, data: [{ 'attribute' => 'supplier_name', 'value' => 'Marc Ribillet Records' }])
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data, user: user_2, created_at: get_time(2022, 3, 10, 0, 18, 30), supplier_id: supplier_1_id, data: { 'lot_code' => '1a', 'attribute' => 'service_codes', 'added' => %w[E.14 E.15], 'removed' => %w[I.14 J.7] })
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 12, 17, 25, 30), supplier_id: supplier_2_id, data: [{ 'attribute' => 'address_line_1', 'value' => '1 Loop daddy' }, { 'attribute' => 'address_town', 'value' => 'New York City' }])
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 12, 17, 26, 30), supplier_id: supplier_2_id, data: [{ 'attribute' => 'address_line_1', 'value' => '2 Loop daddy' }, { 'attribute' => 'address_town', 'value' => 'New Jersey City' }])
  end

  describe '.set_data' do
    let(:snapshot_generator) { described_class.new(snapshot_date_time) }
    let(:supplier_data) { snapshot_generator.instance_variable_get(:@supplier_data) }
    let(:supplier_1_data) { supplier_data.find { |supplier| supplier['id'] == supplier_1_id } }
    let(:supplier_2_data) { supplier_data.find { |supplier| supplier['id'] == supplier_2_id } }

    before { snapshot_generator.send(:set_data) }

    context 'and the snapshot_date_time is 2022/3/6 13:00' do
      let(:snapshot_date_time) { get_time(2022, 3, 6, 13, 0) }

      it 'has the right data for the first supplier' do
        expect(supplier_1_data['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to include('F.12')
        expect(supplier_1_data['active']).to be true
      end

      it 'has the right data for the second supplier' do
        expect(supplier_2_data['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to include('UKC1')
      end
    end

    context 'and the snapshot_date_time is 2022/3/8 9:00' do
      let(:snapshot_date_time) { get_time(2022, 3, 8, 9, 0) }

      it 'has the right data for the first supplier' do
        expect(supplier_1_data['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to include('F.12')
        expect(supplier_1_data['active']).to be false
      end

      it 'has the right data for the second supplier' do
        expect(supplier_2_data['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).not_to include('UKC1')
      end
    end

    context 'and the snapshot_date_time is 2022/3/12 17:25' do
      let(:snapshot_date_time) { get_time(2022, 3, 12, 17, 25) }

      it 'has the right data for the first supplier' do
        service_codes = supplier_1_data['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']

        expect(supplier_1_data['supplier_name']).to eq('Marc Ribillet Records')
        expect(service_codes).to include('E.14', 'E.15')
        expect(service_codes).not_to include('I.14', 'J.7')
      end

      it 'has the right data for the second supplier' do
        expect(supplier_2_data['address_line_1']).to eq('1 Loop daddy')
        expect(supplier_2_data['address_town']).to eq('New York City')
      end
    end

    context 'and the snapshot_date_time is 2022/3/12 17:27' do
      let(:snapshot_date_time) { get_time(2022, 3, 12, 17, 27) }

      it 'has the right data for the first supplier' do
        service_codes = supplier_1_data['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']

        expect(supplier_1_data['supplier_name']).to eq('Marc Ribillet Records')
        expect(service_codes).to include('E.14', 'E.15')
        expect(service_codes).not_to include('I.14', 'J.7')
      end

      it 'has the right data for the second supplier' do
        expect(supplier_2_data['address_line_1']).to eq('2 Loop daddy')
        expect(supplier_2_data['address_town']).to eq('New Jersey City')
      end
    end
  end

  describe '.build_zip_file' do
    let(:snapshot_generator) { described_class.new(snapshot_date_time) }
    let(:snapshot_date_time) { get_time(2022, 3, 6, 13, 0) }
    let(:supplier_data) { snapshot_generator.instance_variable_get(:@supplier_data) }

    let(:supplier_spreadsheet) { instance_double(FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet) }
    let(:fake_spreadsheet_file) { Tempfile.new(['supplier_data', '.xlsx']) }

    before do
      allow(FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Details).to receive(:new).and_return(supplier_spreadsheet)
      allow(FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Services).to receive(:new).and_return(supplier_spreadsheet)
      allow(FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Regions).to receive(:new).and_return(supplier_spreadsheet)
      allow(supplier_spreadsheet).to receive(:build)
      allow(supplier_spreadsheet).to receive(:to_xlsx).and_return('')
      snapshot_generator.build_zip_file
    end

    after { fake_spreadsheet_file.unlink }

    it 'calls the spreadsheet generators' do
      expect(FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Details).to have_received(:new).with(supplier_data, nil, true)
      expect(FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Services).to have_received(:new).with(supplier_data)
      expect(FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Regions).to have_received(:new).with(supplier_data)
    end

    it 'builds the spreadsheet and converts it to xlsx' do
      expect(supplier_spreadsheet).to have_received(:build).exactly(3).time
      expect(supplier_spreadsheet).to have_received(:to_xlsx).exactly(3).time
    end

    context 'and to_zip is called' do
      it 'includes all the files' do
        expect(snapshot_generator.to_zip).to include(
          'RM6232 Suppliers Details (06_03_2022 13_00).xlsx',
          'RM6232 Suppliers Services (06_03_2022 13_00).xlsx',
          'RM6232 Suppliers Regions (06_03_2022 13_00).xlsx'
        )
      end
    end
  end
end
