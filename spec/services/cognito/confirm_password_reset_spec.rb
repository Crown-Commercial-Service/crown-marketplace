require 'rails_helper'

RSpec.describe Cognito::ConfirmPasswordReset do
  let(:username) { create(:user).email }
  let(:password) { 'ValidPass123!' }
  let(:password_confirmation) { 'ValidPass123!' }
  let(:confirmation_code) { '1234' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

  describe '#initialize' do
    let(:confirm_password_reset) { described_class.new(email, password, password_confirmation, confirmation_code) }

    let(:email) { 'user@test.com' }

    let(:confirm_password_reset_attributes) do
      {
        email: confirm_password_reset.email,
        password: confirm_password_reset.password,
        password_confirmation: confirm_password_reset.password_confirmation,
        confirmation_code: confirm_password_reset.confirmation_code
      }
    end

    it 'initialises the object with the attributes' do
      expect(confirm_password_reset_attributes).to eq(
        {
          email: 'user@test.com',
          password: 'ValidPass123!',
          password_confirmation: 'ValidPass123!',
          confirmation_code: '1234'
        }
      )
    end

    context 'when the email has uppercase letters' do
      let(:email) { 'Test@Test.com' }

      it 'makes the email lower case' do
        expect(confirm_password_reset.email).to eq('test@test.com')
      end
    end

    context 'when the email is nil' do
      let(:email) { nil }

      it 'returns nil for the email' do
        expect(confirm_password_reset.email).to be_nil
      end
    end
  end

  describe '#validations' do
    let(:response) { described_class.new(username, password, password_confirmation, confirmation_code) }

    context 'when password shorter than 8 characters' do
      let(:password) { 'Pass!' }
      let(:password_confirmation) { 'Pass!' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end

    context 'when password does not contain at least one uppercase letter' do
      let(:password) { 'password!' }
      let(:password_confirmation) { 'password!' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end

    context 'when password is nil' do
      let(:password) { '' }
      let(:password_confirmation) { 'ValidPass123!' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end

    context 'when password and password confirmation do not match' do
      let(:password) { 'SomeOtherPass123!' }
      let(:password_confirmation) { 'ValidPass123!' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end
  end

  describe '#call' do
    let(:response) { described_class.call(username, password, password_confirmation, confirmation_code) }

    context 'when success' do
      include_context 'with cognito structs'

      before { allow(aws_client).to receive(:confirm_forgot_password).and_return(cognito_session_struct.new(session: '12345')) }

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.error).to be_nil
      end
    end

    context 'when cognito error' do
      before { allow(aws_client).to receive(:confirm_forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops')) }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.errors.full_messages.to_sentence).to eq 'Oops'
      end
    end
  end
end
