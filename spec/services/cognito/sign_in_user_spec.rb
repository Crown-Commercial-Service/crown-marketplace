require 'rails_helper'

RSpec.describe Cognito::SignInUser do
  let(:email) { 'user@email.com' }
  let(:password) { 'ValidPass123!' }
  let(:cookies_disabled) { false }

  describe '#initialize' do
    let(:sign_in_user) { described_class.new(email, password, cookies_disabled) }

    let(:sign_in_user_attributes) do
      {
        email: sign_in_user.email,
        password: sign_in_user.password,
        error: sign_in_user.error,
        needs_password_reset: sign_in_user.needs_password_reset,
        cookies_disabled: sign_in_user.cookies_disabled,
        needs_confirmation: sign_in_user.needs_confirmation
      }
    end

    it 'initialises the object with the attributes' do
      expect(sign_in_user_attributes).to eq(
        {
          email: 'user@email.com',
          password: 'ValidPass123!',
          error: nil,
          needs_password_reset: false,
          cookies_disabled: false,
          needs_confirmation: nil
        }
      )
    end

    context 'when the email has uppercase letters' do
      let(:email) { 'Test@Test.com' }

      it 'makes the email lower case' do
        expect(sign_in_user.email).to eq('test@test.com')
      end
    end

    context 'when the email is nil' do
      let(:email) { nil }

      it 'returns nil for the email' do
        expect(sign_in_user.email).to be_nil
      end
    end
  end

  describe '#call' do
    include_context 'with cognito structs'

    let(:challenge_name) { 'Challenge name' }
    let(:session) { 'Session' }
    let(:user_id_for_srp) { 'User id' }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    let(:sign_in_user) { described_class.new(email, password, cookies_disabled) }

    before do
      allow(sign_in_user).to receive(:sleep)
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
    end

    context 'when success' do
      before do
        allow(aws_client).to receive(:initiate_auth).and_return(initiate_auth_resp_struct.new(challenge_name: challenge_name, session: session, challenge_parameters: { 'USER_ID_FOR_SRP' => user_id_for_srp }))
        sign_in_user.call
      end

      it 'returns success' do
        expect(sign_in_user.success?).to be true
      end

      it 'returns no error' do
        expect(sign_in_user.error).to be_nil
      end

      it 'returns challenge name' do
        expect(sign_in_user.challenge_name).to eq challenge_name
      end

      it 'returns challenge?' do
        expect(sign_in_user.challenge?).to be true
      end

      it 'returns session' do
        expect(sign_in_user.session).to eq session
      end
    end

    context 'when cognito error' do
      before do
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
        sign_in_user.call
      end

      it 'does not return success' do
        expect(sign_in_user.success?).to be false
      end

      it 'does returns cognito error' do
        expect(sign_in_user.errors[:base].first).to eq 'You must provide a correct username or password'
      end
    end

    context 'when user not confirmed' do
      before do
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException.new('oops', 'Oops'))
        sign_in_user.call
      end

      it 'does not return success' do
        expect(sign_in_user.success?).to be false
      end

      it 'does returns cognito error' do
        expect(sign_in_user.errors[:base].first).to eq 'Oops'
      end

      it 'returns needs_confirmation true' do
        expect(sign_in_user.needs_confirmation).to be true
      end
    end

    context 'when password reset required' do
      before do
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::PasswordResetRequiredException.new('oops', 'Oops'))
        sign_in_user.call
      end

      it 'does not return success' do
        expect(sign_in_user.success?).to be false
      end

      it 'does returns cognito error' do
        expect(sign_in_user.errors[:base].first).to eq 'Oops'
      end

      it 'returns need_password_reset true' do
        expect(sign_in_user.needs_password_reset).to be true
      end
    end

    context 'when Cogito error is UserNotFoundException' do
      before do
        allow(aws_client).to receive(:initiate_auth).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('oops', 'Oops'))
        sign_in_user.call
      end

      it 'does not return success' do
        expect(sign_in_user.success?).to be false
      end

      it 'does returns cognito error' do
        expect(sign_in_user.errors[:base].first).to eq 'You must provide a correct username or password'
      end

      it 'returns need_password_reset false' do
        expect(sign_in_user.needs_password_reset).to be false
      end
    end

    context 'when cookies are disabled' do
      let(:cookies_disabled) { true }

      before do
        allow(aws_client).to receive(:initiate_auth).and_return(initiate_auth_resp_struct.new(challenge_name: challenge_name, session: session, challenge_parameters: { 'USER_ID_FOR_SRP' => user_id_for_srp }))
        sign_in_user.call
      end

      it 'does not return success' do
        expect(sign_in_user.success?).to be false
      end

      it 'does returns cognito error' do
        expect(sign_in_user.errors.any?).to be true
      end
    end
  end

  describe 'validation' do
    let(:sign_in_user) { described_class.new(email, password, nil) }
    let(:email) { 'test@test.com' }
    let(:password) { 'Password678?' }

    context 'when considering the email' do
      context 'and it is blank' do
        let(:email) { '' }

        it 'is not valid' do
          expect(sign_in_user.valid?).to be false
        end

        it 'has the correct error message' do
          sign_in_user.valid?
          expect(sign_in_user.errors[:email].first).to eq 'You must provide your email address in the correct format, like name@example.com'
        end
      end

      context 'and it is present' do
        it 'is valid' do
          expect(sign_in_user.valid?).to be true
        end
      end

      context 'and it is present with an invalid format' do
        let(:email) { 'some-person.email@fake.email-place.com' }

        it 'is valid' do
          expect(sign_in_user.valid?).to be true
        end
      end

      context 'and local is present but domain is not' do
        let(:email) { 'some-person@' }

        it 'is not valid and has the correct error message' do
          expect(sign_in_user.valid?).to be false
          expect(sign_in_user.errors[:email].first).to eq 'You must provide your email address in the correct format, like name@example.com'
        end
      end

      context 'and local is not present but domain is' do
        let(:email) { '@some-domain.com' }

        it 'is not valid and has the correct error message' do
          expect(sign_in_user.valid?).to be false
          expect(sign_in_user.errors[:email].first).to eq 'You must provide your email address in the correct format, like name@example.com'
        end
      end

      context 'and local is not present and domain is also not' do
        let(:email) { '@' }

        it 'is not valid and has the correct error message' do
          expect(sign_in_user.valid?).to be false
          expect(sign_in_user.errors[:email].first).to eq 'You must provide your email address in the correct format, like name@example.com'
        end
      end

      context 'and domain and local are present, but there are two @ symbols' do
        let(:email) { 'dom@@ain.com' }

        it 'is invalid and gives the correct error message' do
          expect(sign_in_user.valid?).to be false
          expect(sign_in_user.errors[:email].first).to eq 'You must provide your email address in the correct format, like name@example.com'
        end
      end

      context 'and there is an extra @ symbol in the domain' do
        let(:email) { 'local@domain@com' }

        it 'is invalid and gives the correct error message' do
          expect(sign_in_user.valid?).to be false
          expect(sign_in_user.errors[:email].first).to eq 'You must provide your email address in the correct format, like name@example.com'
        end
      end
    end

    context 'when considering the password' do
      context 'and it is blank' do
        let(:password) { '' }

        it 'is not valid' do
          expect(sign_in_user.valid?).to be false
        end

        it 'has the correct error message' do
          sign_in_user.valid?
          expect(sign_in_user.errors[:password].first).to eq 'You must provide your password'
        end
      end

      context 'and it is present' do
        it 'is valid' do
          expect(sign_in_user.valid?).to be true
        end
      end

      context 'and it is present with an invalid format' do
        let(:password) { 'not a valid password' }

        it 'is valid' do
          expect(sign_in_user.valid?).to be true
        end
      end
    end
  end
end
