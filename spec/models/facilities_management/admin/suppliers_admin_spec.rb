require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SuppliersAdmin, type: :model do
  subject(:suppliers_admin) { FacilitiesManagement::Admin::SuppliersAdmin.find(id) }

  let(:id) { 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }

  describe '.replace_services_for_lot' do
    let(:target_lot) { '1b' }
    let(:changed_lot_data) { suppliers_admin.lot_data[target_lot] }

    context 'when there are services selected' do
      let(:new_services) { %w[bish bosh bash] }

      before { suppliers_admin.replace_services_for_lot(new_services, target_lot) }

      it 'modifies services of correct lot' do
        expect(changed_lot_data['services']).to eq(new_services)
      end
    end

    context 'when there are no services selected' do
      let(:new_services) { nil }

      before { suppliers_admin.replace_services_for_lot(new_services, target_lot) }

      it 'modifies services to be an empty array' do
        expect(changed_lot_data['services']).to eq([])
      end
    end
  end
end
