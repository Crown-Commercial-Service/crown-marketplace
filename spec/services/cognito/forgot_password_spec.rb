require 'rails_helper'

RSpec.describe Cognito::ForgotPassword do
  let(:email) { 'test@email.com' }
  let(:invalid_email_char) { '@!"£$£"' }
  let(:invalid_email) { 'someRandomString' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  describe '#call' do
    context 'when success' do
      include_context 'with cognito structs'

      let(:response) { described_class.call(email) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:forgot_password).and_return(forgot_password_resp_struct.new('USER_ID_FOR_SRP' => email))
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
        allow(aws_client).to receive(:forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(email)
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        response = described_class.call(email)
        expect(response.error).to eq 'Oops'
      end
    end

    context 'when cognito error is UserNotFoundException' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(email)
        expect(response.success?).to be true
      end

      it 'does returns cognito error' do
        response = described_class.call(email)
        expect(response.error).to be_nil
      end
    end

    context 'when user enter invalid_email_char' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      end

      it 'does not return success' do
        response = described_class.call(invalid_email_char)
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        response = described_class.call(invalid_email_char)
        expect(response.error).to eq 'Enter your email address in the correct format, like name@example.com'
      end
    end

    context 'when user enter invalid_email' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      end

      it 'does not return success' do
        response = described_class.call(invalid_email)
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        response = described_class.call(invalid_email)
        expect(response.error).to eq 'Enter your email address in the correct format, like name@example.com'
      end
    end
  end
end
