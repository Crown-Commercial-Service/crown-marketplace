require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierData::Edit, type: :model do
  describe '.log_change' do
    let(:supplier) { create(:facilities_management_rm6232_admin_suppliers_admin) }
    let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, facilities_management_rm6232_supplier_id: supplier.id) }
    let(:user) { create(:user) }
    let(:result) { described_class.log_change(user, model) }

    before { model.update(**atrributes) }

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
      let(:atrributes) { { service_codes: service_codes } }

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
end
