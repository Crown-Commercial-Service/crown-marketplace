require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::PasswordsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  describe 'GET new' do
    context 'when the framework is live' do
      include_context 'and RM3830 is live'

      it 'renders the new page' do
        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'when the framework is not live' do
      it 'renders the new page' do
        get :new

        expect(response).to render_template(:new)
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'POST create' do
    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Cognito::ForgotPassword).to receive(:forgot_password).and_return(true)
      # rubocop:enable RSpec/AnyInstance
    end

    context 'when the framework is live' do
      include_context 'and RM3830 is live'

      context 'when no exception is raised' do
        before do
          post :create, params: { cognito_forgot_password: { email: } }
          cookies.update(response.cookies)
        end

        context 'when the email is invalid' do
          let(:email) { 'testtest.com' }

          it 'renders the new page' do
            expect(response).to render_template(:new)
          end

          it 'does not set the crown_marketplace_reset_email cookie' do
            expect(cookies[:crown_marketplace_reset_email]).to be_nil
          end
        end

        context 'when the email is valid' do
          let(:email) { 'test@test.com' }

          it 'redirects to facilities_management_rm3830_admin_edit_user_password_path' do
            expect(response).to redirect_to facilities_management_rm3830_admin_edit_user_password_path
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
          post :create, params: { cognito_forgot_password: { email: 'test@test.com' } }
        end

        context 'and the error is UserNotFoundException' do
          let(:error) { Aws::CognitoIdentityProvider::Errors::UserNotFoundException }

          it 'redirects to the edit password page' do
            expect(response).to redirect_to facilities_management_rm3830_admin_edit_user_password_path
          end
        end

        context 'and the error is InvalidParameterException' do
          let(:error) { Aws::CognitoIdentityProvider::Errors::InvalidParameterException }

          it 'renders the new page' do
            expect(response).to render_template(:new)
          end
        end

        context 'and the error is ServiceError' do
          let(:error) { Aws::CognitoIdentityProvider::Errors::ServiceError }

          it 'renders the new page' do
            expect(response).to render_template(:new)
          end
        end
      end
    end

    context 'when the framework is not live' do
      let(:email) { 'test@test.com' }

      before do
        post :create, params: { cognito_forgot_password: { email: 'test@test.com' } }
        cookies.update(response.cookies)
      end

      it 'redirects to facilities_management_rm3830_admin_edit_user_password_path' do
        expect(response).to redirect_to facilities_management_rm3830_admin_edit_user_password_path
      end

      it 'sets the crown_marketplace_reset_email cookie' do
        expect(cookies[:crown_marketplace_reset_email]).to eq 'test@test.com'
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe 'GET edit' do
    context 'when the framework is live' do
      include_context 'and RM3830 is live'

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
  end

  describe 'PUT update' do
    before do
      cookies[:crown_marketplace_reset_email] = 'test@email.com'
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Cognito::ConfirmPasswordReset).to receive(:create_user_if_needed).and_return(true)
      allow_any_instance_of(Cognito::ConfirmPasswordReset).to receive(:confirm_forgot_password).and_return(true)
      # rubocop:enable RSpec/AnyInstance
    end

    context 'when the framework is live' do
      include_context 'and RM3830 is live'

      before do
        put :update, params: { cognito_confirm_password_reset: { email: 'test@test.com', password: password, password_confirmation: password, confirmation_code: '123456' } }
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

        it 'redirects to facilities_management_rm3830_admin_password_reset_success_path' do
          expect(response).to redirect_to facilities_management_rm3830_admin_password_reset_success_path
        end

        it 'deletes the crown_marketplace_reset_email cookie' do
          expect(cookies[:crown_marketplace_reset_email]).to be_nil
        end
      end
    end

    context 'when the framework is not live' do
      let(:password) { 'Password12345!' }

      before do
        put :update, params: { cognito_confirm_password_reset: { email: 'test@test.com', password: password, password_confirmation: password, confirmation_code: '123456' } }
        cookies.update(response.cookies)
      end

      it 'redirects to facilities_management_rm3830_admin_password_reset_success_path' do
        expect(response).to redirect_to facilities_management_rm3830_admin_password_reset_success_path
      end

      it 'deletes the crown_marketplace_reset_email cookie' do
        expect(cookies[:crown_marketplace_reset_email]).to be_nil
      end
    end
  end

  describe 'GET password_reset_success' do
    context 'when the framework is live' do
      include_context 'and RM3830 is live'

      it 'renders the password_reset_success page' do
        get :password_reset_success

        expect(response).to render_template(:password_reset_success)
      end
    end

    context 'when the framework is not live' do
      it 'renders the password_reset_success page' do
        get :password_reset_success

        expect(response).to render_template(:password_reset_success)
      end
    end
  end
end
