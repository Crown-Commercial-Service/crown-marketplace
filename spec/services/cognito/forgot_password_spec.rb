require 'rails_helper'

RSpec.describe Cognito::ForgotPassword do
  let(:email) { 'test@email.com' }
  let(:email_uppercase) { 'Test@Email.com' }
  let(:invalid_email_char) { '@!"£$£"' }
  let(:invalid_email) { 'someRandomString' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  describe '#initialize' do
    let(:forgot_password) { described_class.new(email) }

    let(:email) { 'user@test.com' }

    let(:forgot_password_attributes) do
      {
        email: forgot_password.email,
        error: forgot_password.error
      }
    end

    it 'initialises the object with the attributes' do
      expect(forgot_password_attributes).to eq(
        {
          email: 'user@test.com',
          error: nil
        }
      )
    end

    context 'when the email has uppercase letters' do
      let(:email) { 'Test@Test.com' }

      it 'makes the email lower case' do
        expect(forgot_password.email).to eq('test@test.com')
      end
    end

    context 'when the email is nil' do
      let(:email) { nil }

      it 'returns nil for the email' do
        expect(forgot_password.email).to be_nil
      end
    end
  end

  describe '#call' do
    let(:response) { described_class.call(email) }

    before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

    context 'when success' do
      include_context 'with cognito structs'

      before { allow(aws_client).to receive(:forgot_password).and_return(forgot_password_resp_struct.new('USER_ID_FOR_SRP' => email)) }

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.error).to be_nil
      end
    end

    context 'when success with an uppercase email' do
      let(:email) { email_uppercase }

      include_context 'with cognito structs'

      before { allow(aws_client).to receive(:forgot_password).and_return(forgot_password_resp_struct.new('USER_ID_FOR_SRP' => email)) }

      it 'converts the email to lowercase' do
        expect(response.email).to eq('test@email.com')
      end

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.errors).to be_empty
      end
    end

    context 'when cognito error' do
      before { allow(aws_client).to receive(:forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops')) }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.errors[:base].first).to eq 'Oops'
      end
    end

    context 'when cognito error is UserNotFoundException' do
      before { allow(aws_client).to receive(:forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('oops', 'Oops')) }

      it 'does not return success' do
        expect(response.success?).to be true
      end

      it 'does returns cognito error' do
        expect(response.errors).to be_empty
      end
    end

    context 'when user enter invalid_email_char' do
      let(:email) { '@!"£$£"' }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.errors[:email].first).to eq 'Enter your email address in the correct format, like name@example.com'
      end
    end

    context 'when user enter invalid_email' do
      let(:email) { 'someRandomString' }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.errors[:email].first).to eq 'Enter your email address in the correct format, like name@example.com'
      end
    end
  end
end
