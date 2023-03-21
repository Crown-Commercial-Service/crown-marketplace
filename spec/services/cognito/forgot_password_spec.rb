require 'rails_helper'

RSpec.describe Cognito::ForgotPassword do
  let(:email) { 'test@email.com' }
  let(:email_upercase) { 'Test@Email.com' }
  let(:invalid_email_char) { '@!"£$£"' }
  let(:invalid_email) { 'someRandomString' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

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

    context 'when success with an upercase email' do
      let(:email) { email_upercase }

      include_context 'with cognito structs'

      before { allow(aws_client).to receive(:forgot_password).and_return(forgot_password_resp_struct.new('USER_ID_FOR_SRP' => email)) }

      it 'converts the email to lowercase' do
        expect(response.email).to eq('test@email.com')
      end

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.error).to be_nil
      end
    end

    context 'when cognito error' do
      before { allow(aws_client).to receive(:forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops')) }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.error).to eq 'Oops'
      end
    end

    context 'when cognito error is UserNotFoundException' do
      before { allow(aws_client).to receive(:forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('oops', 'Oops')) }

      it 'does not return success' do
        expect(response.success?).to be true
      end

      it 'does returns cognito error' do
        expect(response.error).to be_nil
      end
    end

    context 'when user enter invalid_email_char' do
      let(:email) { invalid_email_char }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.error).to eq 'Enter your email address in the correct format, like name@example.com'
      end
    end

    context 'when user enter invalid_email' do
      let(:email) { invalid_email }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.error).to eq 'Enter your email address in the correct format, like name@example.com'
      end
    end
  end
end
