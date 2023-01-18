require 'rails_helper'

RSpec.describe CrownMarketplace::ManageUsersHelper, type: :helper do
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
        email: email,
        telephone_number: telephone_number,
        roles: roles,
        service_access: service_access,
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

      it 'returns blue with enabled' do
        expect(result).to eq [:blue, 'Enabled']
      end
    end

    context 'when the account is not enabled' do
      let(:enabled) { false }

      it 'returns red with disabled' do
        expect(result).to eq [:red, 'Disabled']
      end
    end
  end

  describe '.verified_unverified_status_tag' do
    let(:result) { helper.verified_unverified_status_tag(verified) }

    context 'when the email is verified' do
      let(:verified) { true }

      it 'returns blue with verified' do
        expect(result).to eq [:blue, 'Verified']
      end
    end

    context 'when the email is not verified' do
      let(:verified) { false }

      it 'returns grey with Unverified' do
        expect(result).to eq [:grey, 'Unverified']
      end
    end
  end

  describe '.user_confirmation_status_tag' do
    let(:result) { helper.user_confirmation_status_tag(status) }

    context 'when the current status is UNCONFIRMED' do
      let(:status) { 'UNCONFIRMED' }

      it 'returns grey and UNCONFIRMED' do
        expect(result).to eq [:grey, 'UNCONFIRMED']
      end
    end

    context 'when the current status is CONFIRMED' do
      let(:status) { 'CONFIRMED' }

      it 'returns blue and CONFIRMED' do
        expect(result).to eq [:blue, 'CONFIRMED']
      end
    end

    context 'when the current status is ARCHIVED' do
      let(:status) { 'ARCHIVED' }

      it 'returns grey and ARCHIVED' do
        expect(result).to eq [:grey, 'ARCHIVED']
      end
    end

    context 'when the current status is COMPROMISED' do
      let(:status) { 'COMPROMISED' }

      it 'returns red and COMPROMISED' do
        expect(result).to eq [:red, 'COMPROMISED']
      end
    end

    context 'when the current status is UNKNOWN' do
      let(:status) { 'UNKNOWN' }

      it 'returns grey and UNKNOWN' do
        expect(result).to eq [:grey, 'UNKNOWN']
      end
    end

    context 'when the current status is RESET_REQUIRED' do
      let(:status) { 'RESET_REQUIRED' }

      it 'returns grey and RESET_REQUIRED' do
        expect(result).to eq [:grey, 'RESET_REQUIRED']
      end
    end

    context 'when the current status is FORCE_CHANGE_PASSWORD' do
      let(:status) { 'FORCE_CHANGE_PASSWORD' }

      it 'returns grey and FORCE_CHANGE_PASSWORD' do
        expect(result).to eq [:grey, 'FORCE_CHANGE_PASSWORD']
      end
    end
  end
end
