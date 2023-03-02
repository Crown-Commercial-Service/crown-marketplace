require 'rails_helper'

RSpec.describe CrownMarketplace::ManageUsersHelper do
  describe '.add_users_back_link' do
    let(:result) { helper.add_users_back_link(cognito_admin_user, 'my_section') }

    let(:cognito_admin_user) { Cognito::Admin::User.new(current_user_access, attributes) }
    let(:current_user_access) { :super_admin }
    let(:email) { 'user@crowncommercial.gov.uk' }
    let(:roles) { %w[buyer] }
    let(:telephone_number) { '07123456789' }
    let(:service_access) { %w[fm_access] }

    let(:attributes) do
      {
        email:,
        telephone_number:,
        roles:,
        service_access:,
      }
    end

    context 'when all attributes are present' do
      it 'creates a link with all the attributes' do
        expect(result).to eq '/crown-marketplace/manage-users/my_section/add-user?email=user%40crowncommercial.gov.uk&roles%5B%5D=buyer&service_access%5B%5D=fm_access&telephone_number=07123456789'
      end
    end

    context 'when only attributes are present' do
      let(:telephone_number) { nil }
      let(:service_access) { [] }

      it 'creates a link with only the present attributes' do
        expect(result).to eq '/crown-marketplace/manage-users/my_section/add-user?email=user%40crowncommercial.gov.uk&roles%5B%5D=buyer'
      end
    end
  end

  describe '.enabled_disabled_status_tag' do
    let(:result) { helper.enabled_disabled_status_tag(enabled) }

    context 'when the account is enabled' do
      let(:enabled) { true }

      it 'returns enabled' do
        expect(result).to eq ['Enabled']
      end
    end

    context 'when the account is not enabled' do
      let(:enabled) { false }

      it 'returns disabled with red' do
        expect(result).to eq ['Disabled', :red]
      end
    end
  end

  describe '.verified_unverified_status_tag' do
    let(:result) { helper.verified_unverified_status_tag(verified) }

    context 'when the email is verified' do
      let(:verified) { true }

      it 'returns verified' do
        expect(result).to eq ['Verified']
      end
    end

    context 'when the email is not verified' do
      let(:verified) { false }

      it 'returns Unverified with grey' do
        expect(result).to eq ['Unverified', :grey]
      end
    end
  end

  describe '.user_confirmation_status_tag' do
    let(:result) { helper.user_confirmation_status_tag(status) }

    context 'when the current status is UNCONFIRMED' do
      let(:status) { 'UNCONFIRMED' }

      it 'returns UNCONFIRMED and grey' do
        expect(result).to eq ['UNCONFIRMED', :grey]
      end
    end

    context 'when the current status is CONFIRMED' do
      let(:status) { 'CONFIRMED' }

      it 'returns CONFIRMED and nil' do
        expect(result).to eq ['CONFIRMED', nil]
      end
    end

    context 'when the current status is ARCHIVED' do
      let(:status) { 'ARCHIVED' }

      it 'returns ARCHIVED and grey' do
        expect(result).to eq ['ARCHIVED', :grey]
      end
    end

    context 'when the current status is COMPROMISED' do
      let(:status) { 'COMPROMISED' }

      it 'returns COMPROMISED and red' do
        expect(result).to eq ['COMPROMISED', :red]
      end
    end

    context 'when the current status is UNKNOWN' do
      let(:status) { 'UNKNOWN' }

      it 'returns UNKNOWN and grey' do
        expect(result).to eq ['UNKNOWN', :grey]
      end
    end

    context 'when the current status is RESET_REQUIRED' do
      let(:status) { 'RESET_REQUIRED' }

      it 'returns RESET_REQUIRED and grey' do
        expect(result).to eq ['RESET_REQUIRED', :grey]
      end
    end

    context 'when the current status is FORCE_CHANGE_PASSWORD' do
      let(:status) { 'FORCE_CHANGE_PASSWORD' }

      it 'returns FORCE_CHANGE_PASSWORD and grey' do
        expect(result).to eq ['FORCE_CHANGE_PASSWORD', :grey]
      end
    end
  end
end
