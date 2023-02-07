require 'rails_helper'

RSpec.describe Cognito::ResendConfirmationCode do
  let(:email) { create(:user, :without_detail, cognito_uuid: '12345').email }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  describe '#call' do
    context 'when success' do
      include_context 'with cognito structs'

      let(:response) { described_class.call(email) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:resend_confirmation_code).and_return(resend_confirmation_code_resp_struct.new('USER_ID_FOR_SRP' => email))
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
        allow(aws_client).to receive(:resend_confirmation_code).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
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
  end
end
