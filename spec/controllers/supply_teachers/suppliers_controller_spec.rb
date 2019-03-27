require 'rails_helper'

RSpec.describe SupplyTeachers::SuppliersController, type: :controller, auth: true do
  before do
    permit_framework :supply_teachers
  end

  describe 'GET master_vendors' do
    let(:supplier) { build(:supply_teachers_supplier) }
    let(:suppliers) { [supplier] }

    before do
      allow(SupplyTeachers::Supplier)
        .to receive(:with_master_vendor_rates)
        .and_return(suppliers)
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
    let(:supplier) { build(:supply_teachers_supplier) }
    let(:suppliers) { [supplier] }

    before do
      allow(SupplyTeachers::Supplier)
        .to receive(:with_neutral_vendor_rates)
        .and_return(suppliers)
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

  describe 'GET all suppliers' do
    let(:branch) { create(:supply_teachers_branch) }
    let(:branch1) { create(:supply_teachers_branch) }

    before do
      get :all_suppliers, params: {
        journey: 'supply-teachers',
        looking_for: 'all_suppliers'
      }
    end

    it 'renders the neutral_vendors template' do
      expect(response).to render_template('all_suppliers')
    end

    it 'assigns suppliers with neutral vendor rates to suppliers' do
      expect(assigns(:branches)).to eq([branch, branch1])
    end

    it 'sets the back path to the managed-service-provider question' do
      expected_path = journey_question_path(
        journey: 'supply-teachers',
        slug: 'looking-for',
        looking_for: 'all_suppliers'
      )
      expect(assigns(:back_path)).to eq(expected_path)
    end
  end
end
