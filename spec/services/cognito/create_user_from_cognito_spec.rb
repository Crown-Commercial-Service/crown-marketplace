require 'rails_helper'

RSpec.describe Cognito::CreateUserFromCognito do
  describe '#call' do
    let(:username) { '123456' }
    let(:email) { 'user@email.com' }
    let(:name) { 'Scooby' }
    let(:family_name) { 'Doo' }
    let(:phone_number) { '+447500594946' }
    let(:cognito_user) do
      OpenStruct.new(
        user_attributes: [
          OpenStruct.new(name: 'sub', value: username),
          OpenStruct.new(name: 'email', value: email),
          OpenStruct.new(name: 'name', value: name),
          OpenStruct.new(name: 'family_name', value: family_name),
          OpenStruct.new(name: 'phone_number', value: phone_number)
        ]
      )
    end
    let(:cognito_groups) do
      OpenStruct.new(groups: [
                       OpenStruct.new(group_name: 'buyer'),
                       OpenStruct.new(group_name: 'st_access')
                     ])
    end
    let(:roles) { %i[buyer st_access] }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    context 'when success' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:admin_get_user).and_return(cognito_user)
        allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
      end

      it 'creates user' do
        expect { described_class.call(username) }.to change(User, :count).by 1
      end

      it 'returns the newly created resource' do
        response = described_class.call(username)
        expect(response.user).to eq User.order(created_at: :asc).last
      end

      it 'returns the newly created resource with the right email' do
        response = described_class.call(username)
        expect(response.user.email).to eq email
      end

      it 'returns the newly created resource with the right first name' do
        response = described_class.call(username)
        expect(response.user.first_name).to eq name
      end

      it 'returns the newly created resource with the right last name' do
        response = described_class.call(username)
        expect(response.user.last_name).to eq family_name
      end

      it 'returns the newly created resource with the right phone number' do
        response = described_class.call(username)
        expect(response.user.phone_number).to eq phone_number
      end

      it 'returns the newly created resource with the buyer and st_access role' do
        response = described_class.call(username)
        expect(response.user.has_role?(:buyer)).to eq true
        expect(response.user.has_role?(:st_access)).to eq true
      end

      it 'returns the newly created resource with no fm_access role' do
        response = described_class.call(username)
        expect(response.user.has_role?(:fm_access)).to eq false
      end

      it 'returns the newly created resource with no at_access role' do
        response = described_class.call(username)
        expect(response.user.has_role?(:at_access)).to eq false
      end

      it 'returns the newly created resource with no ls_access role' do
        response = described_class.call(username)
        expect(response.user.has_role?(:ls_access)).to eq false
      end

      it 'returns the newly created resource with no mc_access role' do
        response = described_class.call(username)
        expect(response.user.has_role?(:mc_access)).to eq false
      end

      it 'returns success' do
        response = described_class.call(username)
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        response = described_class.call(username)
        expect(response.error).to eq nil
      end
    end

    context 'when user already exists' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:admin_get_user).and_return(cognito_user)
        allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
        create(:user, cognito_uuid: '0987', email: email, roles: %i[buyer fm_access])
      end

      it 'does not create a new user' do
        expect { described_class.call(username) }.to change(User, :count).by 0
      end

      it 'updates cognito_uuid' do
        response = described_class.call(username)
        expect(response.user.cognito_uuid).to eq username
      end

      it 'updates roles' do
        response = described_class.call(username)
        expect(response.user.has_role?(:st_access)).to eq true
        expect(response.user.has_role?(:buyer)).to eq true
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:admin_get_user).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not create user' do
        expect { described_class.call(username) }.not_to change(User, :count)
      end

      it 'does not return user' do
        response = described_class.call(username)
        expect(response.user).to eq nil
      end

      it 'does not return success' do
        response = described_class.call(username)
        expect(response.success?).to eq false
      end

      it 'returns an error' do
        response = described_class.call(username)
        expect(response.error).to eq 'Oops'
      end
    end
  end
end
