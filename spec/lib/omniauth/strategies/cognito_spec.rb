require 'rails_helper'

RSpec.describe OmniAuth::Strategies::Cognito do
  let(:strategy) do
    app = ->(_env) { [200, {}, ['']] }
    described_class.new(app, callback_path: 'callback-path')
  end

  it 'presents the token subject as the uid' do
    cognito_id_token = Cognito::Token.new('sub' => 'uuid-of-authenticated-user')
    allow(strategy).to receive(:validated_id_token).and_return(cognito_id_token)
    expect(strategy.uid).to eq('uuid-of-authenticated-user')
  end

  it 'includes email address from cognito in the info hash' do
    cognito_id_token = Cognito::Token.new('email' => 'email-of-authenticated-user')
    allow(strategy).to receive(:validated_id_token).and_return(cognito_id_token)
    expect(strategy.info[:email]).to eq('email-of-authenticated-user')
  end
end
