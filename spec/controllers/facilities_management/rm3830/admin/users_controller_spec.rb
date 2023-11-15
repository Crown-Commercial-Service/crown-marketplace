require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::UsersController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  describe 'GET challenge_new' do
    let(:user) { create(:user, cognito_uuid: SecureRandom.uuid, phone_number: Faker::PhoneNumber.cell_phone) }

    before { cookies[:crown_marketplace_challenge_username] = user.cognito_uuid }

    context 'when the framework is live' do
      include_context 'and RM3830 is live'

      before { get :challenge_new, params: { challenge_name: } }

      render_views

      context 'when the challenge is NEW_PASSWORD_REQUIRED' do
        let(:challenge_name) { 'NEW_PASSWORD_REQUIRED' }

        it 'renders the new_password_required partial' do
          expect(response).to render_template(partial: 'base/users/_new_password_required')
        end
      end

      context 'when the challenge is SMS_MFA' do
        let(:challenge_name) { 'SMS_MFA' }

        it 'renders the sms_mfa partial' do
          expect(response).to render_template(partial: 'base/users/_sms_mfa')
        end
      end
    end

    context 'when the framework is not live' do
      before { get :challenge_new, params: { challenge_name: } }

      render_views

      context 'when the challenge is NEW_PASSWORD_REQUIRED' do
        let(:challenge_name) { 'NEW_PASSWORD_REQUIRED' }

        it 'renders the new_password_required partial' do
          expect(response).to render_template(partial: 'base/users/_new_password_required')
        end
      end

      context 'when the challenge is SMS_MFA' do
        let(:challenge_name) { 'SMS_MFA' }

        it 'renders the sms_mfa partial' do
          expect(response).to render_template(partial: 'base/users/_sms_mfa')
        end
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'POST challenge' do
    include_context 'with cognito structs'

    let(:user) { create(:user, cognito_uuid: SecureRandom.uuid, phone_number: Faker::PhoneNumber.cell_phone) }
    let(:session) { 'I_AM_THE_SESSION' }
    let(:username) { user.cognito_uuid }

    before do
      cookies[:crown_marketplace_challenge_session] = session
      cookies[:crown_marketplace_challenge_username] = username
    end

    context 'when the challenge is NEW_PASSWORD_REQUIRED' do
      let(:challenge_name) { 'NEW_PASSWORD_REQUIRED' }
      let(:password) { 'Password12345!' }
      let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }
      let(:new_challenge_name) { nil }
      let(:new_session) { 'I_AM_THE_NEW_SESSION' }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:respond_to_auth_challenge).and_return(respond_to_auth_challenge_resp_struct.new(challenge_name: new_challenge_name, session: new_session))
        allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(admin_create_user_resp_struct.new(user:))
      end

      context 'when the framework is live' do
        include_context 'and RM3830 is live'

        before do
          post :challenge, params: { challenge_name: challenge_name, username: username, session: session, new_password: password, new_password_confirmation: password }
          cookies.update(response.cookies)
        end

        context 'and it is not valid' do
          let(:password) { 'Pas12!' }

          it 'renders challenge_new' do
            expect(response).to render_template(:challenge_new)
          end

          it 'does not delete the cookies' do
            expect(cookies[:crown_marketplace_challenge_session]).to eq(session)
            expect(cookies[:crown_marketplace_challenge_username]).to eq(username)
          end
        end

        context 'and it is valid' do
          context 'and there is an additional challange' do
            let(:new_challenge_name) { 'SMS_MFA' }

            it 'redirects to facilities_management_rm3830_admin_users_challenge_path' do
              expect(response).to redirect_to facilities_management_rm3830_admin_users_challenge_path(challenge_name: new_challenge_name)
            end

            it 'the cookies are updated correctly' do
              expect(cookies[:crown_marketplace_challenge_session]).to eq(new_session)
              expect(cookies[:crown_marketplace_challenge_username]).to eq(username)
            end
          end

          context 'and there is no additional challange' do
            it 'redirects to facilities_management_rm3830_admin_path' do
              expect(response).to redirect_to facilities_management_rm3830_admin_path
            end

            it 'deletes the cookies' do
              expect(cookies[:crown_marketplace_challenge_session]).to be_nil
              expect(cookies[:crown_marketplace_challenge_username]).to be_nil
            end
          end
        end
      end

      context 'when the framework is not live' do
        before do
          post :challenge, params: { challenge_name: challenge_name, username: username, session: session, new_password: password, new_password_confirmation: password }
          cookies.update(response.cookies)
        end

        it 'redirects to facilities_management_rm3830_admin_path' do
          expect(response).to redirect_to facilities_management_rm3830_admin_path
        end

        it 'deletes the cookies' do
          expect(cookies[:crown_marketplace_challenge_session]).to be_nil
          expect(cookies[:crown_marketplace_challenge_username]).to be_nil
        end
      end
    end

    context 'when the challenge is SMS_MFA' do
      let(:challenge_name) { 'SMS_MFA' }
      let(:access_code) { '123456' }
      let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:respond_to_auth_challenge).and_return(respond_to_auth_challenge_resp_struct.new)
        allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(admin_create_user_resp_struct.new(user:))
      end

      context 'when the framework is live' do
        include_context 'and RM3830 is live'

        before do
          post :challenge, params: { challenge_name:, username:, session:, access_code: }
          cookies.update(response.cookies)
        end

        context 'and it is not valid' do
          let(:access_code) { '123' }

          it 'renders challenge_new' do
            expect(response).to render_template(:challenge_new)
          end

          it 'does not delete the cookies' do
            expect(cookies[:crown_marketplace_challenge_session]).to eq(session)
            expect(cookies[:crown_marketplace_challenge_username]).to eq(username)
          end
        end

        context 'and it is valid' do
          it 'redirects to facilities_management_rm3830_admin_path' do
            expect(response).to redirect_to facilities_management_rm3830_admin_path
          end

          it 'deletes the cookies' do
            expect(cookies[:crown_marketplace_challenge_session]).to be_nil
            expect(cookies[:crown_marketplace_challenge_username]).to be_nil
          end
        end
      end

      context 'when the framework is not live' do
        before do
          post :challenge, params: { challenge_name:, username:, session:, access_code: }
          cookies.update(response.cookies)
        end

        it 'redirects to facilities_management_rm3830_admin_path' do
          expect(response).to redirect_to facilities_management_rm3830_admin_path
        end

        it 'deletes the cookies' do
          expect(cookies[:crown_marketplace_challenge_session]).to be_nil
          expect(cookies[:crown_marketplace_challenge_username]).to be_nil
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
