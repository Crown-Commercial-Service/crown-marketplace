require 'rails_helper'

RSpec.describe Login::DfeLogin, type: :model do
  subject(:login) do
    Login.from_omniauth(omniauth_hash)
  end

  let(:email) { 'user@example.com' }

  let(:omniauth_hash) do
    {
      'info' => {
        'email' => email
      },
      'provider' => 'dfe',
      'extra' => {
        'raw_info' => {
          'organisation' => {
            'id' => '047F32E7-FDD5-46E9-89D4-2498C2E77364',
            'name' => 'St Custard’s',
            'urn' => '900002',
            'ukprn' => '90000002',
            'category' => {
              'id' => '001',
              'name' => 'Establishment'
            },
            'type' => school_type
          }
        }
      }
    }
  end

  let(:school_type) do
    {
      'id' => '01',
      'name' => 'Community school'
    }
  end

  let(:whitelisted_email_addresses) { [email] }

  before do
    stub_const(
      'DFE_SIGNIN_WHITELISTED_EMAIL_ADDRESSES', whitelisted_email_addresses.join(',')
    )
  end

  it { is_expected.to be_a(described_class) }

  it { is_expected.to have_attributes(email: email) }

  context 'when the framework is supply_teachers' do
    context 'when the school type is non-profit' do
      let(:school_type) do
        {
          'id' => '01',
          'name' => 'Community school'
        }
      end

      context 'and email address is white-listed' do
        let(:whitelisted_email_addresses) { [email] }

        it 'permits access' do
          expect(login.permit?(:supply_teachers)).to be true
        end
      end

      context 'and email address is not white-listed' do
        let(:whitelisted_email_addresses) { [] }

        it 'denies access' do
          expect(login.permit?(:supply_teachers)).to be false
        end
      end
    end

    context 'when the school type is for-profit' do
      let(:school_type) do
        {
          'id' => '11',
          'name' => 'Other independent school'
        }
      end

      it 'denies access' do
        expect(login.permit?(:supply_teachers)).to be false
      end
    end
  end

  context 'when the framework is anything else' do
    it 'denies access' do
      expect(login.permit?(:management_consultancy)).to be false
    end
  end
end
