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
            'category' => organisaton_category,
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

  let(:organisaton_category) do
    {
      'id' => '001',
      'name' => 'Establishment'
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
      context 'and email whitelisting is disabled' do
        let(:whitelist_enabled) { false }

        it 'permits access to any email address' do
          expect(login.permit?(:supply_teachers)).to be true
        end

        it 'logs the attempt' do
          login.permit?(:supply_teachers)
          expect(Rails.logger).to have_received(:info)
            .with('Login attempt to supply_teachers from dfe > email: user@example.com, result: successful')
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

    context 'when the school type is non-profit and a number' do
      let(:school_type) do
        {
          'id' => 28,
          'name' => 'Academy sponsor led'
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
            .with('Login attempt to supply_teachers from dfe > email: user@example.com, result: successful')
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
          .with('Login attempt to supply_teachers from dfe > email: user@example.com, result: unsuccessful')
      end
    end

    context 'with organisation category checking (fallback)' do
      context 'when the schooltype is nil' do
        let(:school_type) do
          {
            'id' => nil,
            'name' => ''
          }
        end

        it 'allows access' do
          expect(login.permit?(:supply_teachers)).to be true
        end
      end

      context 'when the school type is an empty string' do
        let(:school_type) do
          {
            'id' => '',
            'name' => ''
          }
        end

        it 'allows access' do
          expect(login.permit?(:supply_teachers)).to be true
        end
      end

      context 'when the school type is nil AND the organisation category is nil' do
        let(:school_type) do
          {
            'id' => nil,
            'name' => ''
          }
        end

        let(:organisaton_category) do
          {
            'id' => nil,
            'name' => ''
          }
        end

        it 'denies access' do
          expect(login.permit?(:supply_teachers)).to be false
        end

        it 'logs the user information' do
          login.permit?(:supply_teachers)
          expect(Rails.logger).to have_received(:info)
            .with('Failed login from dfe > email user@example.com, school type nil, organisation category nil')
        end
      end
  
      context 'when the school type is non-profit' do
        let(:school_type) do
          {
            'id' => '01',
            'name' => 'Community school'
          }
        end

        it 'allows access' do
          expect(login.permit?(:supply_teachers)).to be true
        end
      end

      context 'when the school type doesn\'t match anything in the school types csv' do
        let(:school_type) do
          {
            'id' => '999',
            'name' => 'Hogwarts School of Witchcraft and Wizardry'
          }
        end

        it 'allows access' do
          expect(login.permit?(:supply_teachers)).to be true
        end
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
        .with('Login attempt to management_consultancy from dfe > email: user@example.com, result: unsuccessful')
    end
  end
end
