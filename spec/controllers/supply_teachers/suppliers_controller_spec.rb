require 'rails_helper'

module SupplyTeachers
  RSpec.describe SuppliersController, type: :controller do
    describe 'GET master_vendors' do
      let(:supplier) { build(:supplier) }
      let(:suppliers) { [supplier] }

      before do
        allow(Supplier).to receive(:with_master_vendor_rates).and_return(suppliers)
        get :master_vendors, params: {
          journey: 'supply-teachers',
          looking_for: 'managed_service_provider',
          managed_service_provider: 'master_vendor'
        }
      end

      it 'renders the master_vendors template' do
        expect(response).to render_template('master_vendors')
      end

      it 'assigns suppliers with master vendor rates to suppliers' do
        expect(assigns(:suppliers)).to eq(suppliers)
      end

      it 'sets the back path to the managed-service-provider question' do
        expected_path = journey_question_path(
          journey: 'supply-teachers',
          slug: 'managed-service-provider',
          looking_for: 'managed_service_provider',
          managed_service_provider: 'master_vendor'
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end

    describe 'GET neutral_vendors' do
      let(:supplier) { build(:supplier) }
      let(:suppliers) { [supplier] }

      before do
        allow(Supplier).to receive(:with_neutral_vendor_rates).and_return(suppliers)
        get :neutral_vendors, params: {
          journey: 'supply-teachers',
          looking_for: 'managed_service_provider',
          managed_service_provider: 'neutral_vendor'
        }
      end

      it 'renders the neutral_vendors template' do
        expect(response).to render_template('neutral_vendors')
      end

      it 'assigns suppliers with neutral vendor rates to suppliers' do
        expect(assigns(:suppliers)).to eq(suppliers)
      end

      it 'sets the back path to the managed-service-provider question' do
        expected_path = journey_question_path(
          journey: 'supply-teachers',
          slug: 'managed-service-provider',
          looking_for: 'managed_service_provider',
          managed_service_provider: 'neutral_vendor'
        )
        expect(assigns(:back_path)).to eq(expected_path)
      end
    end
  end
end
