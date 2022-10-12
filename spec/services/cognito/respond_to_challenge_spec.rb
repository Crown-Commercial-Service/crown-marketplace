require 'rails_helper'

RSpec.describe Cognito::RespondToChallenge do
  let(:username) { '123456' }
  let(:challenge_name) { 'NEW_PASSWORD_REQUIRED' }
  let(:session) { 'Session' }
  let(:new_password) { 'ValidPass123!' }
  let(:new_password_confirmation) { 'ValidPass123!' }
  let(:access_code) { '123467' }
  let(:new_challenge_name) { 'NEW CHALLENGE' }
  let(:new_session) { 'New session' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  describe '#validations' do
    let(:response) { described_class.new(challenge_name, username, session, new_password: new_password, new_password_confirmation: new_password_confirmation) }

    before do
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      allow(aws_client).to receive(:respond_to_auth_challenge).and_return(OpenStruct.new(challenge_name: new_challenge_name, session: new_session))
      allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(true)
    end

    context 'when password shorter than 8 characters' do
      let(:new_password) { 'Pass!' }
      let(:new_password_confirmation) { 'Pass!' }

      it 'is invalid' do
        expect(response.valid?).to eq false
      end
    end

    context 'when password does not contain at least one uppercase letter' do
      let(:new_password) { 'password!' }
      let(:new_password_confirmation) { 'password!' }

      it 'is invalid' do
        expect(response.valid?).to eq false
      end
    end

    context 'when password is nil' do
      let(:new_password) { '' }
      let(:new_password_confirmation) { 'ValidPass123!' }

      it 'is invalid' do
        expect(response.valid?).to eq false
      end
    end

    context 'when password and password confirmation do not match' do
      let(:new_password) { 'SomeOtherPass123!' }
      let(:new_password_confirmation) { 'ValidPass123!' }

      it 'is invalid' do
        expect(response.valid?).to eq false
      end
    end
  end

  describe '#call' do
    context 'when NEW_PASSWORD_REQUIRED challenge success' do
      let(:response) { described_class.call(challenge_name, username, session, new_password: new_password, new_password_confirmation: new_password_confirmation) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:respond_to_auth_challenge).and_return(OpenStruct.new(challenge_name: new_challenge_name, session: new_session))
        allow(Cognito::CreateUserFromCognito).to receive(:call).and_return(true)
      end

      it 'returns success' do
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        expect(response.error).to eq nil
      end

      it 'returns new_challenge_name' do
        expect(response.new_challenge_name).to eq new_challenge_name
      end

      it 'returns challenge?' do
        expect(response.challenge?).to eq true
      end

      it 'returns new_session' do
        expect(response.new_session).to eq new_session
      end
    end

    context 'when SMS_MFA challenge success' do
      let(:challenge_name) { 'SMS_MFA' }
      let(:response) { described_class.call(challenge_name, username, session, access_code: access_code) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:respond_to_auth_challenge).and_return(OpenStruct.new(challenge_name: new_challenge_name, session: new_session))
      end

      it 'returns success' do
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        expect(response.error).to eq nil
      end

      it 'returns new_challenge_name' do
        expect(response.new_challenge_name).to eq new_challenge_name
      end

      it 'returns challenge?' do
        expect(response.challenge?).to eq true
      end

      it 'returns new_session' do
        expect(response.new_session).to eq new_session
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:respond_to_auth_challenge).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(challenge_name, username, session, new_password: new_password, new_password_confirmation: new_password_confirmation)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(challenge_name, username, session, new_password: new_password, new_password_confirmation: new_password_confirmation)
        expect(response.errors.full_messages.to_sentence).to eq 'Oops'
      end
    end
  end
end
