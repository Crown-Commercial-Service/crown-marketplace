require 'rails_helper'

RSpec.describe Cognito::UpdateUser do
  let(:user) { create(:user, :without_detail, roles: %i[mc_access fm_acess ls_access]) }

  describe '#initialize' do
    let(:update_user) { described_class.new(user) }

    let(:update_user_attributes) do
      {
        user: update_user.user,
        error: update_user.error
      }
    end

    it 'initialises the object with the attributes' do
      expect(update_user_attributes).to eq(
        {
          user: user,
          error: nil
        }
      )
    end
  end

  describe '#call' do
    include_context 'with cognito structs'

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

    let(:response) { described_class.call(user) }

    before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

    context 'when success' do
      before { allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups) }

      it 'returns the newly updated resource' do
        expect(response.user).to eq User.order(created_at: :asc).last
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

    context 'when cognito error' do
      before { allow(aws_client).to receive(:admin_list_groups_for_user).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops')) }

      it 'returns user' do
        expect(response.user).to eq user
      end

      it 'does not return success' do
        expect(response.success?).to be false
      end

      it 'returns an error' do
        expect(response.error).to eq 'Oops'
      end
    end
  end
end
