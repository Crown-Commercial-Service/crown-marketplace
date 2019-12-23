require 'rails_helper'

RSpec.describe Cognito::SignInUser do
  describe '#call' do
    let(:email) { 'user@email.com' }
    let(:password) { 'ValidPass123!' }
    let(:challenge_name) { 'Challenge name' }
    let(:session) { 'Session' }
    let(:user_id_for_srp) { 'User id' }
    let(:cookies_disabled) { false }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    context 'when success' do
      let(:response) { described_class.call(email, password, cookies_disabled) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:initiate_auth).and_return(OpenStruct.new(challenge_name: challenge_name, session: session, challenge_parameters: { 'USER_ID_FOR_SRP' => user_id_for_srp }))
      end

      it 'returns success' do
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        expect(response.error).to eq nil
      end

      it 'returns challenge name' do
        expect(response.challenge_name).to eq challenge_name
      end

      it 'returns challenge?' do
        expect(response.challenge?).to eq true
      end

      it 'returns session' do
        expect(response.session).to eq session
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.error).to eq 'Oops'
      end
    end

    context 'when user not confirmed' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.error).to eq 'Oops'
      end

      it 'returns needs_confirmation true' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.needs_confirmation).to eq true
      end
    end

    context 'when password reset required' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::PasswordResetRequiredException.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.error).to eq 'Oops'
      end

      it 'returns need_password_reset true' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.needs_password_reset).to eq true
      end
    end

    context 'when Cogito error is UserNotFoundException' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.error).to eq I18n.t('activemodel.errors.models.user.incorrect_username_or_password')
      end

      it 'returns need_password_reset false' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.needs_password_reset).to eq false
      end
    end

    context 'when cookies are disabled' do
      let(:cookies_disabled) { true }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:initiate_auth).and_return(OpenStruct.new(challenge_name: challenge_name, session: session, challenge_parameters: { 'USER_ID_FOR_SRP' => user_id_for_srp }))
      end

      it 'does not return success' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(email, password, cookies_disabled)
        expect(response.errors.any?).to eq true
      end
    end
  end
end
