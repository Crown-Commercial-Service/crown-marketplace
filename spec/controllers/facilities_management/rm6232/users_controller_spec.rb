require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::UsersController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }

  describe 'GET confirm_new' do
    context 'when the framework is live' do
      it 'renders the confirm_new page' do
        get :confirm_new

        expect(response).to render_template(:confirm_new)
      end
    end

    context 'when the framework is not live' do
      include_context 'and RM6232 has expired'

      it 'renders the unrecognised framework page with the right http status' do
        get :confirm_new

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST confirm' do
    let(:user) { create(:user) }
    let(:user_email) { user.email }
    let(:confirmation_code) { '123456' }

    # rubocop:disable RSpec/NestedGroups
    context 'when the framework is live' do
      context 'and there is no exception' do
        before do
          cookies[:crown_marketplace_confirmation_email] = user_email
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(Cognito::ConfirmSignUp).to receive(:confirm_sign_up).and_return(true)
          # rubocop:enable RSpec/AnyInstance
          post :confirm, params: { email: user_email, confirmation_code: confirmation_code }
          cookies.update(response.cookies)
        end

        context 'when the information is invalid' do
          let(:confirmation_code) { '' }

          it 'renders confirm_new' do
            expect(response).to render_template(:confirm_new)
          end

          it 'does not delete the crown_marketplace_confirmation_email cookie' do
            expect(cookies[:crown_marketplace_confirmation_email]).to eq user_email
          end
        end

        context 'when the information is valid' do
          it 'redirects to facilities_management_rm6232_path' do
            expect(response).to redirect_to facilities_management_rm6232_path
          end

          it 'deletes the crown_marketplace_confirmation_email cookie' do
            expect(cookies[:crown_marketplace_confirmation_email]).to be_nil
          end
        end
      end

      context 'and there is an exception' do
        before do
          cookies[:crown_marketplace_confirmation_email] = user_email
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(Cognito::ConfirmSignUp).to receive(:confirm_sign_up).and_raise(error.new('Some context', 'Some message'))
          # rubocop:enable RSpec/AnyInstance
          post :confirm, params: { email: user_email, confirmation_code: confirmation_code }
          cookies.update(response.cookies)
        end

        context 'when the exception is generic' do
          let(:error) { Aws::CognitoIdentityProvider::Errors::ServiceError }

          it 'renders confirm_new' do
            expect(response).to render_template(:confirm_new)
          end

          it 'does not delete the crown_marketplace_confirmation_email cookie' do
            expect(cookies[:crown_marketplace_confirmation_email]).to eq user_email
          end
        end

        context 'when the exception is NotAuthorizedException' do
          let(:error) { Aws::CognitoIdentityProvider::Errors::NotAuthorizedException }

          it 'renders confirm_new' do
            expect(response).to render_template(:confirm_new)
          end

          it 'does not delete the crown_marketplace_confirmation_email cookie' do
            expect(cookies[:crown_marketplace_confirmation_email]).to eq user_email
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups

    context 'when the framework is not live' do
      include_context 'and RM6232 has expired'

      it 'renders the unrecognised framework page with the right http status' do
        post :confirm, params: { email: user_email, confirmation_code: '123456' }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST resend_confirmation_email' do
    let(:email) { 'test@testemail.com' }

    context 'when the framework is live' do
      before do
        allow(Cognito::ResendConfirmationCode).to receive(:call).with(email).and_return(Cognito::ResendConfirmationCode.new(email))
        post :resend_confirmation_email, params: { email: email }
      end

      it 'redirects to facilities_management_rm6232_users_confirm_path' do
        expect(response).to redirect_to facilities_management_rm6232_users_confirm_path
      end
    end

    context 'when the framework is not live' do
      include_context 'and RM6232 has expired'

      it 'renders the unrecognised framework page with the right http status' do
        post :resend_confirmation_email, params: { email: email }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET challenge_new' do
    let(:user) { create(:user, cognito_uuid: SecureRandom.uuid, phone_number: Faker::PhoneNumber.cell_phone) }

    before { cookies[:crown_marketplace_challenge_username] = user.cognito_uuid }

    context 'when the framework is live' do
      before { get :challenge_new, params: { challenge_name: challenge_name } }

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
      include_context 'and RM6232 has expired'

      it 'renders the unrecognised framework page with the right http status' do
        get :challenge_new, params: { challenge_name: 'NEW_PASSWORD_REQUIRED' }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
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

    context 'when the framework is live' do
      context 'when the challenge is NEW_PASSWORD_REQUIRED' do
        let(:challenge_name) { 'NEW_PASSWORD_REQUIRED' }
        let(:password) { 'Password12345!' }
        let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }
        let(:new_challenge_name) { nil }
        let(:new_session) { 'I_AM_THE_NEW_SESSION' }

        before do
          allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
          allow(aws_client).to receive(:respond_to_auth_challenge).and_return(respond_to_auth_challenge_resp_struct.new(challenge_name: new_challenge_name, session: new_session))
          allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(admin_create_user_resp_struct.new(user: user))

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

            it 'redirects to facilities_management_rm6232_users_challenge_path' do
              expect(response).to redirect_to facilities_management_rm6232_users_challenge_path(challenge_name: new_challenge_name)
            end

            it 'the cookies are updated correctly' do
              expect(cookies[:crown_marketplace_challenge_session]).to eq(new_session)
              expect(cookies[:crown_marketplace_challenge_username]).to eq(username)
            end
          end

          context 'and there is no additional challange' do
            it 'redirects to facilities_management_rm6232_path' do
              expect(response).to redirect_to facilities_management_rm6232_path
            end

            it 'deletes the cookies' do
              expect(cookies[:crown_marketplace_challenge_session]).to be_nil
              expect(cookies[:crown_marketplace_challenge_username]).to be_nil
            end
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
          allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(admin_create_user_resp_struct.new(user: user))

          post :challenge, params: { challenge_name: challenge_name, username: username, session: session, access_code: access_code }
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
          it 'redirects to facilities_management_rm6232_path' do
            expect(response).to redirect_to facilities_management_rm6232_path
          end

          it 'deletes the cookies' do
            expect(cookies[:crown_marketplace_challenge_session]).to be_nil
            expect(cookies[:crown_marketplace_challenge_username]).to be_nil
          end
        end
      end
    end

    context 'when the framework is not live' do
      include_context 'and RM6232 has expired'

      it 'renders the unrecognised framework page with the right http status' do
        post :challenge, params: { challenge_name: 'SMS_MFA', username: username, session: session }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
