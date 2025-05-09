require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SessionsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }

  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET new' do
    context 'when the framework is live' do
      it 'renders the new page' do
        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when the framework is not live' do
      include_context 'and RM6232 has expired'

      it 'renders the new page' do
        get :new

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST create' do
    let(:user) { create(:user, cognito_uuid: SecureRandom.uuid, phone_number: Faker::PhoneNumber.cell_phone) }
    let(:email) { user.email }
    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    before do
      cookies['test_marketplace_session'] = 'I AM THE SESSION COOKIE'
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Cognito::SignInUser).to receive(:sleep)
      # rubocop:enable RSpec/AnyInstance
    end

    context 'when the log in attempt is unsuccessful' do
      before do
        allow(aws_client).to receive(:initiate_auth).and_raise(exception)

        post :create, params: { user: { email: email, password: 'Password12345!' } }
        cookies.update(response.cookies)
      end

      context 'when the data is invalid' do
        let(:email) { nil }
        let(:exception) { nil }

        it 'renders the new page' do
          expect(response).to render_template(:new)
        end
      end

      context 'when the password needs to be reset' do
        let(:exception) { Aws::CognitoIdentityProvider::Errors::PasswordResetRequiredException.new('oops', 'Oops') }

        it 'redirects to facilities_management_rm6232_admin_edit_user_password_path' do
          expect(response).to redirect_to facilities_management_rm6232_admin_edit_user_password_path
        end

        it 'sets the crown_marketplace_reset_email cookie' do
          expect(cookies[:crown_marketplace_reset_email]).to eq email
        end
      end
    end

    context 'when the login attempt is successful' do
      include_context 'with cognito structs'

      let(:username) { user.cognito_uuid }
      let(:session) { 'I_AM_THE_SESSION' }
      let(:cognito_groups) do
        admin_list_groups_for_user_resp_struct.new(
          groups: [
            cognito_group_struct.new(group_name: 'buyer'),
            cognito_group_struct.new(group_name: 'fm_access')
          ]
        )
      end

      before do
        allow(aws_client).to receive_messages(initiate_auth: initiate_auth_resp_struct.new(challenge_name: challenge_name, session: session, challenge_parameters: { 'USER_ID_FOR_SRP' => username }), admin_list_groups_for_user: cognito_groups)
        allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(admin_create_user_resp_struct.new(user:))
      end

      # rubocop:disable RSpec/NestedGroups
      context 'and the framework is live' do
        before do
          post :create, params: { user: { email: email, password: 'Password12345!' } }
          cookies.update(response.cookies)
        end

        context 'and there is no challenge' do
          let(:challenge_name) { nil }

          it 'redirects to facilities_management_rm6232_admin_path' do
            expect(response).to redirect_to facilities_management_rm6232_admin_path
          end
        end

        context 'and there is a challenge' do
          let(:challenge_name) { 'NEW_PASSWORD_REQUIRED' }

          it 'redirects to facilities_management_rm6232_admin_users_challenge_path' do
            expect(response).to redirect_to facilities_management_rm6232_admin_users_challenge_path(challenge_name:)
          end

          it 'the cookies are updated correctly' do
            expect(cookies[:crown_marketplace_challenge_session]).to eq(session)
            expect(cookies[:crown_marketplace_challenge_username]).to eq(username)
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups

      context 'when the framework is not live' do
        let(:challenge_name) { nil }

        include_context 'and RM6232 has expired'

        before do
          post :create, params: { user: { email: email, password: 'Password12345!' } }
          cookies.update(response.cookies)
        end

        it 'redirects to facilities_management_rm6232_admin_path' do
          expect(response).to redirect_to facilities_management_rm6232_admin_path
        end
      end
    end
  end

  describe 'DELETE destroy' do
    login_fm_buyer

    it 'signs the user out' do
      expect(controller.current_user).not_to be_nil
      delete :destroy
      expect(controller.current_user).to be_nil
    end
  end
end
