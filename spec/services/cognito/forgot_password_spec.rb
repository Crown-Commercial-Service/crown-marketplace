require 'rails_helper'

RSpec.describe Cognito::ForgotPassword do
  let(:email) { 'test@email.com' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  describe '#call' do
    context 'when success' do
      let(:response) { described_class.call(email) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:forgot_password).and_return(OpenStruct.new('USER_ID_FOR_SRP' => email))
      end

      it 'returns success' do
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        expect(response.error).to eq nil
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:forgot_password).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(email)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(email)
        expect(response.error).to eq 'Oops'
      end
    end
  end
end
