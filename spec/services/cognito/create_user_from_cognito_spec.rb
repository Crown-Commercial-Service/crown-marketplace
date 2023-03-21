require 'rails_helper'

RSpec.describe Cognito::CreateUserFromCognito do
  describe '#call' do
    include_context 'with cognito structs'

    let(:username) { '123456' }
    let(:email) { 'user@email.com' }
    let(:name) { 'Scooby' }
    let(:family_name) { 'Doo' }
    let(:phone_number) { '+447500594946' }
    let(:cognito_user) do
      admin_get_user_resp_struct.new(
        user_attributes: [
          cognito_user_attribute_struct.new(name: 'sub', value: username),
          cognito_user_attribute_struct.new(name: 'email', value: email),
          cognito_user_attribute_struct.new(name: 'name', value: name),
          cognito_user_attribute_struct.new(name: 'family_name', value: family_name),
          cognito_user_attribute_struct.new(name: 'phone_number', value: phone_number)
        ]
      )
    end
    let(:cognito_groups) do
      admin_list_groups_for_user_resp_struct.new(
        groups: [
          cognito_group_struct.new(group_name: 'buyer'),
          cognito_group_struct.new(group_name: 'st_access')
        ]
      )
    end
    let(:roles) { %i[buyer st_access] }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    let(:response) { described_class.call(username) }

    before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

    context 'when success' do
      before do
        allow(aws_client).to receive(:admin_get_user).and_return(cognito_user)
        allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
      end

      it 'creates user' do
        expect { response }.to change(User, :count).by 1
      end

      it 'returns the newly created resource' do
        expect(response.user).to eq User.order(created_at: :asc).last
      end

      it 'returns the newly created resource with the right email' do
        expect(response.user.email).to eq email
      end

      it 'returns the newly created resource with the right first name' do
        expect(response.user.first_name).to eq name
      end

      it 'returns the newly created resource with the right last name' do
        expect(response.user.last_name).to eq family_name
      end

      it 'returns the newly created resource with the right phone number' do
        expect(response.user.phone_number).to eq phone_number
      end

      it 'returns the newly created resource with the buyer and st_access role' do
        expect(response.user.has_role?(:buyer)).to be true
        expect(response.user.has_role?(:st_access)).to be true
      end

      it 'returns the newly created resource with no fm_access role' do
        expect(response.user.has_role?(:fm_access)).to be false
      end

      it 'returns the newly created resource with no ls_access role' do
        expect(response.user.has_role?(:ls_access)).to be false
      end

      it 'returns the newly created resource with no mc_access role' do
        expect(response.user.has_role?(:mc_access)).to be false
      end

      it 'returns success' do
        expect(response.success?).to be true
      end

      it 'returns no error' do
        expect(response.error).to be_nil
      end
    end

    context 'when user already exists' do
      before do
        allow(aws_client).to receive(:admin_get_user).and_return(cognito_user)
        allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
        create(:user, :without_detail, cognito_uuid: '0987', email: email, roles: %i[buyer fm_access])
      end

      it 'does not create a new user' do
        expect { response }.not_to change(User, :count)
      end

      it 'updates cognito_uuid' do
        expect(response.user.cognito_uuid).to eq username
      end

      it 'updates roles' do
        expect(response.user.has_role?(:st_access)).to be true
        expect(response.user.has_role?(:buyer)).to be true
      end
    end

    context 'when cognito error' do
      before { allow(aws_client).to receive(:admin_get_user).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops')) }

      it 'does not create user' do
        expect { response }.not_to change(User, :count)
      end

      it 'does not return user' do
        expect(response.user).to be_nil
      end

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'returns an error' do
        expect(response.error).to eq 'Oops'
      end
    end

    context 'when user is a supplier with fm access' do
      let(:cognito_groups) do
        admin_list_groups_for_user_resp_struct.new(
          groups: [
            cognito_group_struct.new(group_name: 'supplier'),
            cognito_group_struct.new(group_name: 'fm_access')
          ]
        )
      end

      before do
        allow(aws_client).to receive(:admin_get_user).and_return(cognito_user)
        allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
      end

      context 'when supplier detail exists with the same contact_name' do
        before do
          create(:facilities_management_rm3830_supplier_detail, contact_email: email)
          create(:facilities_management_rm3830_supplier_detail)
        end

        it 'matches the right supplier detail to the user record' do
          expect(response.user.supplier_detail.contact_email).to eq response.user.email
        end
      end

      context 'when supplier detail does not exist with the same contact_name' do
        before do
          create(:facilities_management_rm3830_supplier_detail)
        end

        it 'leaves the supplier_detail blank' do
          expect(response.user.supplier_detail).to be_nil
        end
      end
    end
  end
end
