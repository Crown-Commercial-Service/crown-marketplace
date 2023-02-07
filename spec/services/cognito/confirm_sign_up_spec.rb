require 'rails_helper'

RSpec.describe Cognito::ConfirmSignUp do
  let(:email) { 'user@test.com' }
  let(:user) { create(:user, :without_detail, email: email, confirmed_at: nil) }
  let(:confirmation_code) { '123456' }
  let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

  describe '#validations' do
    let(:response) { described_class.new(user.email, confirmation_code) }

    before do
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      allow(aws_client).to receive(:confirm_sign_up).and_return(JSON[{ user_sub: '1234'.to_json }])
    end

    context 'when confirmation_code shorter than 6 characters' do
      let(:confirmation_code) { '123' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end

    context 'when confirmation_code contains other characters than numbers' do
      let(:confirmation_code) { 'invalid' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end

    context 'when confirmation_code is nil' do
      let(:confirmation_code) { '' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end

    context 'when email is nil' do
      let(:email) { '' }

      it 'is invalid' do
        expect(response.valid?).to be false
      end
    end
  end

  describe '#call' do
    let(:response) { described_class.call(user.email, confirmation_code) }

    context 'when success' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:confirm_sign_up).and_return(JSON[{ user_sub: '1234'.to_json }])
        response
      end

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.error).to be_nil
      end

      it 'confirms user' do
        user.reload
        expect(user.confirmed?).to be true
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:confirm_sign_up).and_raise(error.new('Some context', 'Some message'))
        response
      end

      context 'and the error is generic' do
        let(:error) { Aws::CognitoIdentityProvider::Errors::ServiceError }

        it 'sets the error and success will be false' do
          expect(response.errors[:confirmation_code].first).to eq 'Some message'
          expect(response.success?).to be false
        end

        it 'does not confirm user' do
          user.reload
          expect(user.confirmed?).to be false
        end
      end

      context 'and the error is NotAuthorizedException' do
        let(:error) { Aws::CognitoIdentityProvider::Errors::NotAuthorizedException }

        it 'sets the error and success will be false' do
          expect(response.errors[:confirmation_code].first).to eq 'Invalid verification code provided, please try again'
          expect(response.success?).to be false
        end

        it 'does not confirm user' do
          user.reload
          expect(user.confirmed?).to be false
        end
      end
    end
  end
end
