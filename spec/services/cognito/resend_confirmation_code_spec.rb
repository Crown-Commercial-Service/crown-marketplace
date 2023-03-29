require 'rails_helper'

RSpec.describe Cognito::ResendConfirmationCode do
  let(:email) { create(:user, :without_detail, cognito_uuid: '12345').email }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  let(:response) { described_class.call(email) }

  before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

  describe '#initialize' do
    let(:resend_confirmation_code) { described_class.new(email) }

    let(:email) { 'user@test.com' }

    let(:resend_confirmation_code_attributes) do
      {
        email: resend_confirmation_code.email,
        error: resend_confirmation_code.error
      }
    end

    it 'initialises the object with the attributes' do
      expect(resend_confirmation_code_attributes).to eq(
        {
          email: 'user@test.com',
          error: nil
        }
      )
    end

    context 'when the email has uppercase letters' do
      let(:email) { 'Test@Test.com' }

      it 'makes the email lower case' do
        expect(resend_confirmation_code.email).to eq('test@test.com')
      end
    end

    context 'when the email is nil' do
      let(:email) { nil }

      it 'returns nil for the email' do
        expect(resend_confirmation_code.email).to be_nil
      end
    end
  end

  describe '#call' do
    context 'when success' do
      include_context 'with cognito structs'

      before { allow(aws_client).to receive(:resend_confirmation_code).and_return(resend_confirmation_code_resp_struct.new('USER_ID_FOR_SRP' => email)) }

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.error).to be_nil
      end
    end

    context 'when cognito error' do
      before { allow(aws_client).to receive(:resend_confirmation_code).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops')) }

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'does returns cognito error' do
        expect(response.error).to eq 'Oops'
      end
    end
  end
end
