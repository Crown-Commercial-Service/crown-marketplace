require 'rails_helper'

RSpec.describe Cognito::UserPool do
  describe '#keys_url' do
    let(:user_pool) { described_class.new('aws-region', 'user-pool-id') }

    it 'returns the url of the cognito user pool public keys' do
      expected_key_url = 'https://cognito-idp.aws-region.amazonaws.com/user-pool-id/.well-known/jwks.json'
      expect(user_pool.keys_url).to eq(expected_key_url)
    end
  end

  describe '#json_web_keys' do
    let(:region) { 'aws-region' }
    let(:user_pool_id) { 'user-pool-id' }
    let(:user_pool) { described_class.new(region, user_pool_id) }
    let(:key_1) { { kid: '1234example=', alg: 'RS256', kty: 'RSA', e: 'AQAB', n: '1234567890', use: 'sig' } }
    let(:key_2) { { kid: '5678example=', alg: 'RS256', kty: 'RSA', e: 'AQAB', n: '987654321', use: 'sig' } }
    let(:jwks) { { keys: [key_1, key_2] } }

    before do
      stub_request(:get, "https://cognito-idp.#{region}.amazonaws.com/#{user_pool_id}/.well-known/jwks.json")
        .to_return(status: 200,
                   body: jwks.to_json,
                   headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a jwk set of the public keys retrieved from cognito' do
      expect(user_pool.json_web_keys).to include(key_1, key_2)
    end
  end

  describe '#find_key' do
    let(:user_pool) { described_class.new('aws-region', 'user-pool-id') }
    let(:key_1) { JSON::JWK.new(kid: 'key-1-id') }
    let(:key_2) { JSON::JWK.new(kid: 'key-2-id') }

    before do
      allow(key_1).to receive(:to_key).and_return('key-1')
      allow(key_2).to receive(:to_key).and_return('key-2')

      allow(user_pool).to receive(:json_web_keys).and_return([key_1, key_2])
    end

    it 'returns key as openssl key object' do
      key = user_pool.find_key('key-2-id')
      expect(key).to eq('key-2')
    end
  end

  describe '#idp_url' do
    let(:user_pool) { described_class.new('aws-region', 'user-pool-id') }

    it 'returns the idp url of the cognito user pool' do
      expect(user_pool.idp_url).to eq('https://cognito-idp.aws-region.amazonaws.com/user-pool-id')
    end
  end
end
