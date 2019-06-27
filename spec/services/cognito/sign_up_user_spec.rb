require 'rails_helper'

RSpec.describe Cognito::SignUpUser do
  describe '#call' do
    let(:params) do
      {
        email: 'user@email.com',
        password: 'ValidPass123!',
        password_confirmation: 'ValidPass123!',
        first_name: 'Name',
        last_name: 'Surname',
        phone_number: '+4475000000'
      }
    end
    let(:roles) { %i[buyer st_access] }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    context 'when success' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_return(JSON[{ user_sub: '12345'.to_json }])
        allow(aws_client).to receive(:admin_add_user_to_group).and_return(JSON[{ user_sub: '12345'.to_json }])
      end

      it 'creates user' do
        expect { described_class.call(params, roles) }.to change(User, :count).by 1
      end

      it 'returns the newly created resource' do
        response = described_class.call(params, roles)
        expect(response.user).to eq User.order(created_at: :asc).last
      end

      it 'returns success' do
        response = described_class.call(params, roles)
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        response = described_class.call(params, roles)
        expect(response.error).to eq nil
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not create user' do
        expect { described_class.call(params, roles) }.not_to change(User, :count)
      end

      it 'does not return user' do
        response = described_class.call(params, roles)
        expect(response.user).to eq nil
      end

      it 'does not return success' do
        response = described_class.call(params, roles)
        expect(response.success?).to eq false
      end

      it 'returns an error' do
        response = described_class.call(params, roles)
        expect(response.error).to eq 'Oops'
      end
    end
  end
end
