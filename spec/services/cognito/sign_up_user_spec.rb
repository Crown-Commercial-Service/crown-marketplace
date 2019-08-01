require 'rails_helper'

RSpec.describe Cognito::SignUpUser do
  describe '#call' do
    let(:email) { 'user@crowncommercial.gov.uk' }
    let(:password) { 'ValidPass123!' }
    let(:password_confirmation) { 'ValidPass123!' }
    let(:roles) { %i[buyer st_access] }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    describe '#validations' do
      let(:response) { described_class.new(email, password, password_confirmation, roles) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_return(JSON[{ user_sub: '12345'.to_json }])
        allow(aws_client).to receive(:admin_add_user_to_group).and_return(JSON[{ user_sub: '12345'.to_json }])
      end

      context 'when password shorter than 8 characters' do
        let(:password) { 'Pass!' }
        let(:password_confirmation) { 'Pass!' }

        it 'is invalid' do
          expect(response.valid?).to eq false
        end
      end

      context 'when password does not contain at least one uppercase letter' do
        let(:password) { 'password!' }
        let(:password_confirmation) { 'password!' }

        it 'is invalid' do
          expect(response.valid?).to eq false
        end
      end

      context 'when password is nil' do
        let(:password) { '' }
        let(:password_confirmation) { 'ValidPass123!' }

        it 'is invalid' do
          expect(response.valid?).to eq false
        end
      end

      context 'when password and password confirmation do not match' do
        let(:password) { 'SomeOtherPass123!' }
        let(:password_confirmation) { 'ValidPass123!' }

        it 'is invalid' do
          expect(response.valid?).to eq false
        end
      end

      context 'when email is nil' do
        let(:email) { '' }

        it 'is invalid' do
          expect(response.valid?).to eq false
        end
      end

      context 'when email domain not in whitelist' do
        let(:email) { 'user@test.com' }

        it 'is invalid' do
          expect(response.valid?).to eq false
        end
      end
    end

    context 'when success' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_return(JSON[{ user_sub: '12345'.to_json }])
        allow(aws_client).to receive(:admin_add_user_to_group).and_return(JSON[{ user_sub: '12345'.to_json }])
      end

      it 'creates user' do
        expect { described_class.call(email, password, password_confirmation, roles) }.to change(User, :count).by 1
      end

      it 'returns the newly created resource' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.user).to eq User.order(created_at: :asc).last
      end

      it 'returns success' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.error).to eq nil
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not create user' do
        expect { described_class.call(email, password, password_confirmation, roles) }.not_to change(User, :count)
      end

      it 'does not return user' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.user).to eq nil
      end

      it 'does not return success' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.success?).to eq false
      end

      it 'returns an error' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.errors.empty?).to eq false
      end
    end
  end
end
