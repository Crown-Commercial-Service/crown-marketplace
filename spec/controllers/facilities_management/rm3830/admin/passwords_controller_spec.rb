require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::PasswordsController, type: :controller do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  describe 'GET new' do
    before { get :new }

    it 'renders the new page' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Cognito::ForgotPassword).to receive(:forgot_password).and_return(true)
      # rubocop:enable RSpec/AnyInstance
      post :create, params: { email: email }
      cookies.update(response.cookies)
    end

    context 'when the email is invalid' do
      let(:email) { 'testtest.com' }

      it 'redirects to the facilities_management_rm3830_admin_new_user_password_path' do
        expect(response).to redirect_to facilities_management_rm3830_admin_new_user_password_path
      end

      it 'does not set the crown_marketplace_reset_email cookie' do
        expect(cookies[:crown_marketplace_reset_email]).to be nil
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

  describe 'GET edit' do
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

  describe 'PUT update' do
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

      it 'redirects to facilities_management_rm3830_admin_password_reset_success_path' do
        expect(response).to redirect_to facilities_management_rm3830_admin_password_reset_success_path
      end

      it 'deletes the crown_marketplace_reset_email cookie' do
        expect(cookies[:crown_marketplace_reset_email]).to be nil
      end
    end
  end

  describe 'GET password_reset_success' do
    before { get :password_reset_success }

    it 'renders the password_reset_success page' do
      expect(response).to render_template(:password_reset_success)
    end
  end
end
