require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::UsersController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }

  describe '#challenge_new' do
    before do
      sign_in user
      allow(Cognito::RespondToChallenge).to receive(:new).and_return(true)
      allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(instance_double(Cognito::CreateUserFromCognito, user: user))
    end

    context 'when user has a phone number' do
      let(:user) { create(:user, :with_phone_number) }

      it 'returns http success' do
        get :challenge_new, params: { challenge_name: 'FORCE_CHANGE_PASSWORD', username: user.email, session: 'test' }
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @user_phone' do
        get :challenge_new, params: { challenge_name: 'FORCE_CHANGE_PASSWORD', username: user.email, session: 'test' }
        expect(assigns(:user_phone)).not_to be_nil
      end
    end

    context 'when user does not have a phone number' do
      let(:user) { create(:user) }

      it 'returns http success' do
        get :challenge_new, params: { challenge_name: 'FORCE_CHANGE_PASSWORD', username: user.email, session: 'test' }
        expect(response).to have_http_status(:ok)
      end

      it 'does not assign @user_phone' do
        get :challenge_new, params: { challenge_name: 'FORCE_CHANGE_PASSWORD', username: user.email, session: 'test' }
        expect(assigns(:user_phone)).to be_nil
      end
    end
  end
end
