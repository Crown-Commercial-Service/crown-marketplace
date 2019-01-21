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

  let(:whitelist_enabled) { true }
  let(:whitelisted_email_addresses) { [email] }

  before do
    allow(Marketplace).to receive(:dfe_signin_whitelist_enabled?)
      .and_return(whitelist_enabled)
    allow(Marketplace).to receive(:dfe_signin_whitelisted_email_addresses)
      .and_return(whitelisted_email_addresses)
    allow(Rails.logger).to receive(:info)
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

      context 'and email whitelisting is disabled' do
        let(:whitelist_enabled) { false }

        it 'permits access to any email address' do
          expect(login.permit?(:supply_teachers)).to be true
        end

        it 'logs the attempt' do
          login.permit?(:supply_teachers)
          expect(Rails.logger).to have_received(:info)
            .with('Login attempt from dfe > email: user@example.com, school_id: 01, result: successful')
        end
      end

      context 'and email address is white-listed' do
        let(:whitelist_enabled) { true }
        let(:whitelisted_email_addresses) { [email] }

        it 'permits access to whitelisted email address' do
          expect(login.permit?(:supply_teachers)).to be true
        end
      end

      context 'and email address is not white-listed' do
        let(:whitelist_enabled) { true }
        let(:whitelisted_email_addresses) { ['another-user@example.com'] }

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

      it 'logs the attempt' do
        login.permit?(:supply_teachers)
        expect(Rails.logger).to have_received(:info)
          .with('Login attempt from dfe > email: user@example.com, school_id: 11, result: unsuccessful')
      end
    end
  end

  context 'when the framework is anything else' do
    it 'denies access' do
      expect(login.permit?(:management_consultancy)).to be false
    end

    it 'logs the attempt' do
      login.permit?(:management_consultancy)
      expect(Rails.logger).to have_received(:info)
        .with('Login attempt from dfe > email: user@example.com, school_id: 01, result: unsuccessful')
    end
  end
end
