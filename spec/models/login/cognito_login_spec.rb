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

  before do
    allow(Rails.logger).to receive(:info)
  end

  it { is_expected.to be_a(described_class) }

  it { is_expected.to have_attributes(email: email) }

  context 'when the framework is supply_teachers' do
    it 'permits access' do
      expect(login.permit?(:supply_teachers)).to be true
    end

    it 'logs the attempt' do
      login.permit?(:supply_teachers)
      expect(Rails.logger).to have_received(:info)
        .with('Login attempt from cognito > email: user@example.com, result: successful')
    end
  end

  context 'when the framework is anything else' do
    it 'permits access' do
      expect(login.permit?(:management_consultancy)).to be true
    end
  end
end
