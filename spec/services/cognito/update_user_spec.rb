require 'rails_helper'

RSpec.describe Cognito::UpdateUser do
  describe '#call' do
    let(:user) { create(:user, :without_detail, roles: %i[mc_access fm_acess ls_access]) }
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
        allow(aws_client).to receive(:admin_list_groups_for_user).and_return(cognito_groups)
      end

      it 'returns the newly updated resource' do
        response = described_class.call(user)
        expect(response.user).to eq User.order(created_at: :asc).last
      end

      it 'returns the newly created resource with the buyer and st_access role' do
        response = described_class.call(user)
        expect(response.user.has_role?(:buyer)).to eq true
        expect(response.user.has_role?(:st_access)).to eq true
      end

      it 'returns the newly created resource with no fm_access role' do
        response = described_class.call(user)
        expect(response.user.has_role?(:fm_access)).to eq false
      end

      it 'returns the newly created resource with no ls_access role' do
        response = described_class.call(user)
        expect(response.user.has_role?(:ls_access)).to eq false
      end

      it 'returns the newly created resource with no mc_access role' do
        response = described_class.call(user)
        expect(response.user.has_role?(:mc_access)).to eq false
      end

      it 'returns success' do
        response = described_class.call(user)
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        response = described_class.call(user)
        expect(response.error).to eq nil
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:admin_list_groups_for_user).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'returns user' do
        response = described_class.call(user)
        expect(response.user).to eq user
      end

      it 'does not return success' do
        response = described_class.call(user)
        expect(response.success?).to eq false
      end

      it 'returns an error' do
        response = described_class.call(user)
        expect(response.error).to eq 'Oops'
      end
    end
  end
end
