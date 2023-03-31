require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierData do
  describe '.latest_data' do
    let(:latest_data) { described_class.create }

    before do
      4.times { described_class.create(created_at: 1.day.ago) }
      latest_data
    end

    it 'is the latest set of data' do
      expect(described_class.latest_data).to eq latest_data
    end
  end

  describe '.oldest_data_created_at' do
    let(:created_at) { Time.zone.local(2022, 7, 5, 13, 45) }

    before { described_class.latest_data.update(created_at:) }

    it 'returns the 5th of July 2022' do
      expect(described_class.oldest_data_created_at).to eq(created_at)
    end
  end

  describe '.oldest_data_created_at_string' do
    let(:created_at) { Time.zone.local(2022, 7, 5, 12, 45) }

    before { described_class.latest_data.update(created_at:) }

    it 'returns 5 July 2022, 13:45' do
      expect(described_class.oldest_data_created_at_string).to eq(' 5 July 2022, 13:45')
    end
  end

  describe '.audit_logs' do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:supplier_data) { described_class.latest_data }
    let(:edit_1) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data, user: user_1, created_at: dates[1]) }
    let(:edit_2) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, user: user_2, created_at: dates[2]) }
    let(:edit_3) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_region_lot_data, user: user_1, created_at: dates[3]) }
    let(:dates) { [4.days.ago, 3.days.ago, 2.days.ago, 1.day.ago] }

    before do
      supplier_data.update(created_at: dates[0])
      edit_1
      edit_2
      edit_3
    end

    # rubocop:disable RSpec/ExampleLength
    it 'creates the audit logs from the edits' do
      expected_audit_logs = [
        {
          id: edit_3.id,
          short_id: "##{edit_3.id[..7]}",
          user_email: user_1.email,
          change_type: 'lot_data',
          true_change_type: 'region_codes'
        },
        {
          id: edit_2.id,
          short_id: "##{edit_2.id[..7]}",
          user_email: user_2.email,
          change_type: 'details',
          true_change_type: 'details'
        },
        {
          id: edit_1.id,
          short_id: "##{edit_1.id[..7]}",
          user_email: user_1.email,
          change_type: 'lot_data',
          true_change_type: 'service_codes'
        },
        {
          id: supplier_data.id,
          short_id: "##{supplier_data.id[..7]}",
          user_email: nil,
          change_type: 'upload',
          true_change_type: 'upload'
        }
      ]

      expect(described_class.audit_logs.map { |change_log| change_log.except(:created_at) }).to eq(expected_audit_logs)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe '.true_change_type' do
    let(:supplier_data) { described_class.latest_data }

    it 'returns upload' do
      expect(supplier_data.true_change_type).to eq('upload')
    end
  end

  describe '.short_id' do
    let(:supplier_data) { described_class.latest_data }

    it 'returns the shortened uuid' do
      expect(supplier_data.short_id).to eq("##{supplier_data.id[..7]}")
    end
  end
end
