require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::PasswordsController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }

  describe 'GET new' do
    context 'when the framework is live' do
      it 'renders the new page' do
        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when the framework is not live' do
      include_context 'and RM6232 is not live'

      it 'renders the unrecognised framework page with the right http status' do
        get :new

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST create' do
    context 'when no exception is raised' do
      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Cognito::ForgotPassword).to receive(:forgot_password).and_return(true)
        # rubocop:enable RSpec/AnyInstance
        post :create, params: { email: email }
        cookies.update(response.cookies)
      end

      context 'when the email is invalid' do
        let(:email) { 'testtest.com' }

        it 'redirects to the facilities_management_rm6232_new_user_password_path' do
          expect(response).to redirect_to facilities_management_rm6232_new_user_password_path
        end

        it 'does not set the crown_marketplace_reset_email cookie' do
          expect(cookies[:crown_marketplace_reset_email]).to be_nil
        end
      end

      context 'when the email is valid' do
        let(:email) { 'test@test.com' }

        it 'redirects to facilities_management_rm6232_edit_user_password_path' do
          expect(response).to redirect_to facilities_management_rm6232_edit_user_password_path
        end

        it 'sets the crown_marketplace_reset_email cookie' do
          expect(cookies[:crown_marketplace_reset_email]).to eq 'test@test.com'
        end
      end
    end

    context 'when the email is valid but an exception is raised' do
      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Cognito::ForgotPassword).to receive(:forgot_password).and_raise(error.new('Some context', 'Some message'))
        # rubocop:enable RSpec/AnyInstance
        post :create, params: { email: 'test@test.com' }
      end

      context 'and the error is UserNotFoundException' do
        let(:error) { Aws::CognitoIdentityProvider::Errors::UserNotFoundException }

        it 'redirects to the edit password page' do
          expect(response).to redirect_to facilities_management_rm6232_edit_user_password_path
        end
      end

      context 'and the error is InvalidParameterException' do
        let(:error) { Aws::CognitoIdentityProvider::Errors::InvalidParameterException }

        it 'redirects to the new password page' do
          expect(response).to redirect_to facilities_management_rm6232_new_user_password_path
        end
      end

      context 'and the error is ServiceError' do
        let(:error) { Aws::CognitoIdentityProvider::Errors::ServiceError }

        it 'redirects to the new password page' do
          expect(response).to redirect_to facilities_management_rm6232_new_user_password_path
        end
      end
    end
  end

  describe 'GET edit' do
    context 'when the framework is live' do
      before do
        cookies[:crown_marketplace_reset_email] = 'test@email.com'
        get :edit
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end

      it 'the email has been set correctly in the response object' do
        expect(assigns(:response).email).to eq('test@email.com')
      end
    end

    context 'when the framework is not live' do
      include_context 'and RM6232 is not live'

      it 'renders the unrecognised framework page with the right http status' do
        get :edit

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT update' do
    context 'when the framework is live' do
      before do
        cookies[:crown_marketplace_reset_email] = 'test@email.com'
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Cognito::ConfirmPasswordReset).to receive(:create_user_if_needed).and_return(true)
        allow_any_instance_of(Cognito::ConfirmPasswordReset).to receive(:confirm_forgot_password).and_return(true)
        # rubocop:enable RSpec/AnyInstance
        put :update, params: { email: 'test@test.com', password: password, password_confirmation: password, confirmation_code: '123456' }
        cookies.update(response.cookies)
      end

      context 'when the reset password is invalid' do
        let(:password) { 'Pas12!' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not delete the crown_marketplace_reset_email cookie' do
          expect(cookies[:crown_marketplace_reset_email]).to eq 'test@email.com'
        end
      end

      context 'when the reset password is valid' do
        let(:password) { 'Password12345!' }

        it 'redirects to facilities_management_rm6232_password_reset_success_path' do
          expect(response).to redirect_to facilities_management_rm6232_password_reset_success_path
        end

        it 'deletes the crown_marketplace_reset_email cookie' do
          expect(cookies[:crown_marketplace_reset_email]).to be_nil
        end
      end
    end

    context 'when the framework is not live' do
      include_context 'and RM6232 is not live'

      it 'renders the unrecognised framework page with the right http status' do
        put :update, params: { email: 'test@test.com', password: 'Password12345!', password_confirmation: 'Password12345', confirmation_code: '123456' }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET password_reset_success' do
    it 'renders the password_reset_success page' do
      get :password_reset_success

      expect(response).to render_template(:password_reset_success)
    end
  end

  context 'when the framework is not live' do
    include_context 'and RM6232 is not live'

    it 'renders the unrecognised framework page with the right http status' do
      get :password_reset_success

      expect(response).to render_template('home/unrecognised_framework')
      expect(response).to have_http_status(:bad_request)
    end
  end
end
