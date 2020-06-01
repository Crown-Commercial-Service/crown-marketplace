require 'rails_helper'
RSpec.describe FacilitiesManagement::BuildingsController, type: :controller do
  describe 'GET #index' do
    context 'when logging in as a fm buyer with details' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:found)
      end
    end

    context 'when logging in as an st buyer' do
      login_st_buyer_with_detail
      it 'redirects to the not permitted page' do
        get :index

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:found)
    end

    context 'when logging in as an mc buyer' do
      login_mc_buyer_with_detail
      it 'redirects to the not permitted page' do
        get :new

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe '#ensure_postcode_is_valid' do
    context 'when the potcode is blank' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('')).to eq ''
      end
    end

    context 'when the postcode is empty space' do
      it 'returns the blank postcode' do
        expect(controller.ensure_postcode_is_valid('  ')).to eq '  '
        expect(controller.ensure_postcode_is_valid(' ')).to eq ' '
      end
    end

    context 'when the postcode is not a valid postcode' do
      it 'returns the blank postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode2 = "#{('aa11a'..'zz99z').to_a.sample} #{('1a'..'9z').to_a.sample}"
        postcode3 = "#{('aa1'..'zz9').to_a.sample} #{('1a'..'9z').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2
        expect(controller.ensure_postcode_is_valid(postcode3)).to eq postcode3
      end
    end

    context 'when the postcode is a valid postcode' do
      it 'returns the matching postcode' do
        postcode1 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        postcode2 = "#{('aa1'..'zz9').to_a.sample} #{('1aa'..'9zz').to_a.sample}"
        expect(controller.ensure_postcode_is_valid(postcode1)).to eq postcode1
        expect(controller.ensure_postcode_is_valid(postcode2)).to eq postcode2
      end
    end
  end

  describe 'GET #show' do
    context 'when logging in as the fm buyer that created the building' do
      let(:building) { create(:facilities_management_building, user_id: subject.current_user.id) }

      login_fm_buyer_with_details
      it 'returns http success' do
        get :show, params: { id: building.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logging in a different fm buyer' do
      let(:building) { create(:facilities_management_building, user_id: create(:user).id) }

      login_fm_buyer_with_details
      it 'redirects to the not permitted page' do
        get :show, params: { id: building.id }

        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end
end
