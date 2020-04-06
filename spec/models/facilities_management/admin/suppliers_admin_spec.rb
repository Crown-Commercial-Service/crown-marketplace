require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SuppliersAdmin, type: :model do
  subject(:suppliers_admin) { FacilitiesManagement::Admin::SuppliersAdmin.find(id) }

  let(:id) { 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }

  describe '.replace_services_for_lot' do
    let(:new_services) { %w[bish bosh bash] }
    let(:target_lot) { '1b' }
    let(:changed_lot_data) { suppliers_admin.data['lots'].select { |lot| lot['lot_number'] == target_lot } .first }

    before { suppliers_admin.replace_services_for_lot(new_services, target_lot) }

    it 'modifies services of correct lot' do
      expect(changed_lot_data['services']).to eq(new_services)
    end
  end
end
