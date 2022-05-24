require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementsController, type: :controller do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }

  login_fm_buyer_with_details

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :new

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: controller.current_user.buyer_detail.id)
    end
  end

  describe 'GET new' do
    before { get :new, params: { annual_contract_value: 123_456, region_codes: ['UKC1'], service_codes: ['E.1'] } }

    it 'renders the correct template' do
      expect(response).to render_template('new')
    end

    it 'sets the back path and text correctly' do
      expect(assigns(:back_path)).to eq '/facilities-management/RM6232/annual-contract-value?annual_contract_value=123456&region_codes%5B%5D=UKC1&service_codes%5B%5D=E.1'
      expect(assigns(:back_text)).to eq 'Return to annual contract value'
    end

    it 'sets the suppliers' do
      expect(assigns(:suppliers).class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::ActiveRecord_Relation'
    end

    it 'sets the procurement with the correct details' do
      expect(
        assigns(:procurement).attributes.slice('user_id', 'service_codes', 'region_codes', 'annual_contract_value', 'lot_number')
      ).to eq(
        { 'user_id' => controller.current_user.id,
          'service_codes' => ['E.1'],
          'region_codes' => ['UKC1'],
          'annual_contract_value' => 123_456,
          'lot_number' => '2a' }
      )
    end
  end
end
