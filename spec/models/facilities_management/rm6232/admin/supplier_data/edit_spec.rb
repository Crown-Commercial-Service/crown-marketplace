require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierData::Edit do
  describe '.log_change' do
    let(:supplier) { create(:facilities_management_rm6232_admin_suppliers_admin) }
    let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, facilities_management_rm6232_supplier_id: supplier.id) }
    let(:user) { create(:user) }
    let(:result) { described_class.log_change(user, model) }

    before { model.update(atrributes) }

    context 'when the model is supplier admin' do
      let(:model) { supplier }
      let(:atrributes) { { active: status } }

      context 'and there are changes' do
        let(:status) { false }
        let(:data) do
          [
            {
              attribute: 'active',
              value: false
            }
          ]
        end

        it 'logs the changes' do
          expect { result }.to change(described_class, :count).by(1)
          expect(result.attributes.slice('supplier_id', 'change_type', 'data').deep_symbolize_keys).to eq(
            {
              supplier_id: supplier.id,
              change_type: 'details',
              data: data
            }
          )
        end
      end

      context 'and there are no changes' do
        let(:status) { true }

        it 'returns nil' do
          expect(result).to be_nil
        end
      end
    end

    context 'when the model is supplier lot data' do
      let(:model) { lot_data }
      let(:atrributes) { { service_codes: } }

      context 'and there are changes' do
        let(:service_codes) { %w[E.16 H.6 P.11 F.4] }
        let(:data) do
          {
            attribute: 'service_codes',
            lot_code: '1a',
            added: %w[F.4],
            removed: []
          }
        end

        it 'logs the changes' do
          expect { result }.to change(described_class, :count).by(1)
          expect(result.attributes.slice('supplier_id', 'change_type', 'data').deep_symbolize_keys).to eq(
            {
              supplier_id: supplier.id,
              change_type: 'lot_data',
              data: data
            }
          )
        end
      end

      context 'and there are no changes' do
        let(:service_codes) { %w[E.16 H.6 P.11] }

        it 'returns nil' do
          expect(result).to be_nil
        end
      end
    end
  end

  describe '.true_change_type' do
    let(:result) { edit.true_change_type }

    context 'when the change_type is details' do
      let(:edit) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details) }

      it 'returns details' do
        expect(result).to eq('details')
      end
    end

    context 'when the change_type is lot_data' do
      context 'and the attribute is service_codes' do
        let(:edit) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data) }

        it 'returns service_codes' do
          expect(result).to eq('service_codes')
        end
      end

      context 'and the attribute is region_codes' do
        let(:edit) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_region_lot_data) }

        it 'returns region_codes' do
          expect(result).to eq('region_codes')
        end
      end
    end
  end

  describe '.short_id' do
    let(:edit) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data) }

    it 'returns the shortened uuid' do
      expect(edit.short_id).to eq("##{edit.id[..7]}")
    end
  end

  shared_context 'when there are edits' do
    let(:supplier_data) { FacilitiesManagement::RM6232::Admin::SupplierData.latest_data }
    let(:supplier) { FacilitiesManagement::RM6232::Supplier.find(supplier_data.data.first['id']) }
    let(:edit_1) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_service_lot_data, created_at: dates[0]) }
    let(:edit_2) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_details, created_at: dates[1]) }
    let(:edit_3) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_region_lot_data, created_at: dates[2]) }
    let(:edit_4) { create(:facilities_management_rm6232_admin_supplier_data_edit, :with_status, created_at: dates[3]) }
    let(:dates) { [4.days.ago, 3.days.ago, 2.days.ago, 1.day.ago] }

    before do
      edit_1
      edit_2
      edit_3
      edit_4
    end
  end

  # rubocop:disable RSpec/MultipleExpectations
  describe '.current_supplier_data' do
    include_context 'when there are edits'

    context 'when there are no previous changes' do
      let(:result) { edit_1.current_supplier_data }

      it 'includes the changes in the returned data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes + ['A.1']
        expect(result['active']).to be true
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be_nil
      end
    end

    context 'when there is one previous changes' do
      let(:result) { edit_2.current_supplier_data }

      it 'includes the changes in the returned data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes + ['A.1']
        expect(result['active']).to be false
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be_nil
      end
    end

    context 'when there are multiple previous changes' do
      let(:result) { edit_3.current_supplier_data }

      it 'includes the changes in the returned data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes + ['A.1']
        expect(result['active']).to be false
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes - ['UKC1']
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be_nil
      end
    end

    context 'when there are even more previous changes' do
      let(:result) { edit_4.current_supplier_data }

      it 'includes the changes in the returned data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes + ['A.1']
        expect(result['active']).to be false
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes - ['UKC1']
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be false
      end
    end
  end

  describe '.previous_supplier_data' do
    include_context 'when there are edits'

    context 'when there are no previous changes' do
      let(:result) { edit_1.previous_supplier_data }

      it 'matches the data in supplier data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes
        expect(result['active']).to be true
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be_nil
      end
    end

    context 'when there is one previous changes' do
      let(:result) { edit_2.previous_supplier_data }

      it 'includes only previous the changes in the returned data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes + ['A.1']
        expect(result['active']).to be true
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be_nil
      end
    end

    context 'when there are multiple previous changes' do
      let(:result) { edit_3.previous_supplier_data }

      it 'includes only previous the changes in the returned data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes + ['A.1']
        expect(result['active']).to be false
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be_nil
      end
    end

    context 'when there are even more previous changes' do
      let(:result) { edit_4.previous_supplier_data }

      it 'includes only previous the changes in the returned data' do
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['service_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').service_codes + ['A.1']
        expect(result['active']).to be false
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['region_codes']).to eq supplier.lot_data.find_by(lot_code: '1a').region_codes - ['UKC1']
        expect(result['lot_data'].find { |lot_data| lot_data['lot_code'] == '1a' }['active']).to be_nil
      end
    end
  end
  # rubocop:enable RSpec/MultipleExpectations
end
