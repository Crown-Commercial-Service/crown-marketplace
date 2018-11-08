require 'rails_helper'

RSpec.describe OmniAuth::Strategies::Cognito do
  let(:strategy) do
    app = ->(_env) { [200, {}, ['']] }
    described_class.new(app, callback_path: 'callback-path')
  end

  it 'presents the token subject as the uid' do
    cognito_id_token = {
      'sub' => 'uuid-of-authenticated-user'
    }
    allow(strategy).to receive(:validated_id_token).and_return(cognito_id_token)
    expect(strategy.uid).to eq('uuid-of-authenticated-user')
  end

  it 'includes email address from cognito in the info hash' do
    cognito_id_token = {
      'email' => 'email-of-authenticated-user'
    }
    allow(strategy).to receive(:validated_id_token).and_return(cognito_id_token)
    expect(strategy.info[:email]).to eq('email-of-authenticated-user')
  end

  describe OmniAuth::Strategies::Cognito::TokenDecoder do
    describe '#unverified_header' do
      it 'decodes the token and returns the header' do
        payload = { sub: 'token-subject' }
        token = JSON::JWT.new(payload)
        token.header = { 'kid' => 'key-id' }

        decoder = described_class.new(token.to_s)

        expect(decoder.unverified_header).to include('kid' => 'key-id')
      end
    end

    describe '#decode' do
      it 'verifies token using matching key in jwk set' do
        key1 = OpenSSL::PKey::RSA.generate(2048).public_key
        key2 = OpenSSL::PKey::RSA.generate(2048).public_key

        key1_jwk = key1.to_jwk(kid: 'key-1')
        key2_jwk = key2.to_jwk(kid: 'key-2')
        jwks = [key1_jwk, key2_jwk]

        allow(key1_jwk).to receive(:to_key).and_return('key-1-rsa')
        allow(key2_jwk).to receive(:to_key).and_return('key-2-rsa')
        allow(JSON::JWT).to receive(:decode).with('token', 'key-1-rsa').and_return('decoded-payload')

        decoder = described_class.new('token')
        expect(decoder.decode(jwks, 'key-1')).to eq('decoded-payload')
      end
    end
  end
end
