require 'rails_helper'

RSpec.describe Cognito::ConfirmPasswordReset do
  let(:username) { create(:user).email }
  let(:password) { 'ValidPass123!' }
  let(:password_confirmation) { 'ValidPass123!' }
  let(:confirmation_code) { '1234' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  describe '#validations' do
    let(:response) { described_class.new(username, password, password_confirmation, confirmation_code) }

    before do
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
    end

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
    context 'when success' do
      include_context 'with cognito structs'

      let(:response) { described_class.call(username, password, password_confirmation, confirmation_code) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:confirm_forgot_password).and_return(cognito_session_struct.new(session: '12345'))
      end

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.error).to be_nil
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:confirm_forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(username, password, password_confirmation, confirmation_code)
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        response = described_class.call(username, password, password_confirmation, confirmation_code)
        expect(response.errors.full_messages.to_sentence).to eq 'Oops'
      end
    end
  end
end
