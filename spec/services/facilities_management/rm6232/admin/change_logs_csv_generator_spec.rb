require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::ChangeLogsCsvGenerator do
  let(:user_1) { create(:user, email: 'reiner.braun@attackontitn.pa') }
  let(:user_2) { create(:user, email: 'bertholdt.hoover@attackontitn.pa') }
  let(:new_upload) { create(:facilities_management_rm6232_admin_upload, user: user_2) }
  let(:supplier_data_1) { FacilitiesManagement::RM6232::Admin::SupplierData.latest_data }
  let(:supplier_data_2) { FacilitiesManagement::RM6232::Admin::SupplierData.create(upload: new_upload, data: supplier_data_1.data, created_at: get_time(2022, 3, 8, 10, 0)) }
  let(:supplier_1_id) { supplier_data_1.data.find { |data| data['supplier_name'] == 'Abshire, Schumm and Farrell' }['id'] }
  let(:supplier_2_id) { supplier_data_1.data.find { |data| data['supplier_name'] == 'Skiles LLC' }['id'] }

  def get_time(*)
    Time.zone.local(*).in_time_zone('London')
  end

  before do
    supplier_data_1.update(created_at: get_time(2022, 3, 4, 12, 55))
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data, user: user_1, created_at: get_time(2022, 3, 5, 1, 11), supplier_id: supplier_1_id, data: { 'lot_code' => '1a', 'attribute' => 'service_codes', 'added' => %w[F.12], 'removed' => [] })
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 6, 13, 26), supplier_id: supplier_1_id)
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_region_lot_data, user: user_1, created_at: get_time(2022, 3, 7, 4, 59), supplier_id: supplier_2_id)
    supplier_data_2
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 9, 12, 0), supplier_id: supplier_1_id, data: [{ 'attribute' => 'supplier_name', 'value' => 'Marc Ribillet Records' }])
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data, user: user_2, created_at: get_time(2022, 3, 10, 0, 18), supplier_id: supplier_1_id, data: { 'lot_code' => '1a', 'attribute' => 'service_codes', 'added' => %w[E.14 E.15], 'removed' => %w[I.14 J.7] })
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_status, user: user_1, created_at: get_time(2022, 3, 11, 0, 18), supplier_id: supplier_1_id, data: { 'lot_code' => '1a', 'attribute' => 'active', 'added' => true, 'removed' => false })
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 12, 17, 25), supplier_id: supplier_2_id, data: [{ 'attribute' => 'address_line_1', 'value' => '1 Loop daddy' }, { 'attribute' => 'address_town', 'value' => 'New York City' }])
    create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: get_time(2022, 3, 12, 17, 26), supplier_id: supplier_2_id, data: [{ 'attribute' => 'address_line_1', 'value' => '2 Loop daddy' }, { 'attribute' => 'address_town', 'value' => 'New Jersey City' }])
  end

  describe '.generate_csv' do
    let(:generated_csv) { CSV.parse(described_class.generate_csv) }

    it 'has the right headers' do
      expect(generated_csv.first).to eq(['Log item', 'Date of change', 'User', 'Supplier name', 'Change type', 'Changes'])
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'has the correct data in rows' do
      expect(generated_csv[1][1..]).to eq(['12/03/2022 17:26', 'bertholdt.hoover@attackontitn.pa', 'Skiles LLC', 'Details', "Building and street - FROM: 1 Loop daddy TO: 2 Loop daddy\nTown or city - FROM: New York City TO: New Jersey City"])
      expect(generated_csv[2][1..]).to eq(['12/03/2022 17:25', 'bertholdt.hoover@attackontitn.pa', 'Skiles LLC', 'Details', "Building and street - FROM: 40828 Joellen Summit TO: 1 Loop daddy\nTown or city - FROM: Danialborough TO: New York City"])
      expect(generated_csv[3][1..]).to eq(['11/03/2022 00:18', 'reiner.braun@attackontitn.pa', 'Marc Ribillet Records', 'Lot status', "Lot code: 1a\nLot status - FROM: Inactive TO: Active"])
      expect(generated_csv[4][1..]).to eq(['10/03/2022 00:18', 'bertholdt.hoover@attackontitn.pa', 'Marc Ribillet Records', 'Services', "Lot code: 1a\nAdded items: E.14 Catering equipment maintenance|E.15 Audio Visual (AV) equipment maintenance\nRemoved items: I.14 Cleaning of curtains and window blinds|J.7 Clocks"])
      expect(generated_csv[5][1..]).to eq(['09/03/2022 12:00', 'bertholdt.hoover@attackontitn.pa', 'Marc Ribillet Records', 'Details', 'Supplier name - FROM: Abshire, Schumm and Farrell TO: Marc Ribillet Records'])
      expect(generated_csv[6][1..]).to eq(['08/03/2022 10:00', 'bertholdt.hoover@attackontitn.pa', 'N/A', 'Data uploaded', "Upload: http://localhost/facilities-management/RM6232/admin/uploads/#{new_upload.id}"])
      expect(generated_csv[7][1..]).to eq(['07/03/2022 04:59', 'reiner.braun@attackontitn.pa', 'Skiles LLC', 'Regions', "Lot code: 1a\nRemoved items: UKC1 Tees Valley and Durham"])
      expect(generated_csv[8][1..]).to eq(['06/03/2022 13:26', 'bertholdt.hoover@attackontitn.pa', 'Abshire, Schumm and Farrell', 'Details', 'Status - FROM: Active TO: Inactive'])
      expect(generated_csv[9][1..]).to eq(['05/03/2022 01:11', 'reiner.braun@attackontitn.pa', 'Abshire, Schumm and Farrell', 'Services', "Lot code: 1a\nAdded items: F.12 Radon Gas Management Services"])
      expect(generated_csv[10][1..]).to eq(['04/03/2022 12:55', 'During a deployment', 'N/A', 'Data uploaded', 'N/A'])
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
