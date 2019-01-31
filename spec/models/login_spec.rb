require 'rails_helper'

RSpec.describe Login, type: :model do
  subject(:login) do
    Login.from_omniauth(omniauth_hash)
  end

  let(:email) { 'user@example.com' }
  let(:provider) { 'unknown' }

  let(:omniauth_hash) do
    {
      'info' => {
        'email' => email
      },
      'provider' => provider
    }
  end

  it 'raises an UnknownProvider error' do
    expect { login }.to raise_error(Login::UnknownProvider)
  end
end
