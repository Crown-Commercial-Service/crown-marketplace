require 'rails_helper'

RSpec.describe Login::CognitoLogin, type: :model do
  subject(:login) do
    Login.from_omniauth(omniauth_hash)
  end

  let(:email) { 'user@example.com' }

  let(:omniauth_hash) do
    {
      'info' => {
        'email' => email
      },
      'provider' => 'cognito'
    }
  end

  it { is_expected.to be_a(described_class) }

  it { is_expected.to have_attributes(email: email) }

  context 'when the framework is supply_teachers' do
    context 'when Cognito is enabled for supply teachers' do
      before do
        allow(Marketplace)
          .to receive(:supply_teachers_cognito_enabled?)
          .and_return(true)
      end

      it 'permits access' do
        expect(login.permit?(:supply_teachers)).to be true
      end
    end

    context 'when Cognito is not enabled for supply teachers' do
      before do
        allow(Marketplace)
          .to receive(:supply_teachers_cognito_enabled?)
          .and_return(false)
      end

      it 'denies access' do
        expect(login.permit?(:supply_teachers)).to be false
      end
    end
  end

  context 'when the framework is anything else' do
    it 'permits access' do
      expect(login.permit?(:management_consultancy)).to be true
    end
  end
end
