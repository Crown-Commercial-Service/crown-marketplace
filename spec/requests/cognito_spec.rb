require 'rails_helper'

RSpec.describe 'Cognito authorisation', type: :request do
  describe 'GET /auth/cognito' do
    let(:redirected_to) { URI.parse(response.location) }
    let(:query_params) { Rack::Utils.parse_query(redirected_to.query) }

    before do
      get '/auth/cognito'
    end

    it 'redirects to the URL of our AWS Cognito user pool' do
      user_pool_site = URI.parse(ENV['COGNITO_USER_POOL_SITE'])
      expect(redirected_to.host).to eq(user_pool_site.host)
    end

    it 'redirects to the AWS authorization endpoint' do
      expect(redirected_to.path).to eq('/oauth2/authorize')
    end

    it 'includes our cognito client id in the querystring' do
      expect(query_params['client_id']).to eq(ENV['COGNITO_CLIENT_ID'])
    end

    it 'includes our callback URI in the querystring' do
      expect(query_params['redirect_uri']).to match('/auth/cognito/callback')
    end

    it 'sets the scope to email and openid in the querystring' do
      expect(query_params['scope']).to eq('email openid')
    end
  end

  describe 'GET /auth/cognito/callback' do
    let(:state) do
      get '/auth/cognito'
      redirected_to = URI.parse(response.location)
      query_params = Rack::Utils.parse_query(redirected_to.query)
      query_params['state']
    end

    let(:cognito_jwt_payload) do
      {
        aud: ENV['COGNITO_CLIENT_ID'],
        token_use: 'id',
        iss: "https://cognito-idp.#{ENV['COGNITO_AWS_REGION']}.amazonaws.com/#{ENV['COGNITO_USER_POOL_ID']}",
        exp: 5.minutes.from_now.to_i,
        iat: 1541434118,
        email: 'email-address-of-cognito-user'
      }
    end

    let(:signed_cognito_id_token) do
      key_and_id = cognito_public_keys.sample
      token = JSON::JWT.new(cognito_jwt_payload)
      token.kid = key_and_id[:id]
      token.alg = cognito_key_algorithm
      token.sign(key_and_id[:key], cognito_key_algorithm).to_s
    end

    let(:cognito_key_algorithm) { 'RS256' }

    let(:cognito_public_keys) do
      [
        { id: SecureRandom.uuid, key: OpenSSL::PKey::RSA.generate(2048) },
        { id: SecureRandom.uuid, key: OpenSSL::PKey::RSA.generate(2048) }
      ]
    end

    let(:cognito_public_keys_as_jwks) do
      jwks = cognito_public_keys.map do |key_and_id|
        key_and_id[:key].public_key.to_jwk(alg: cognito_key_algorithm, kid: key_and_id[:id])
      end
      JSON::JWK::Set.new(jwks)
    end

    let(:cognito_oauth2_token_response) do
      {
        id_token: signed_cognito_id_token,
        access_token: 'access-token',
        refresh_token: 'refresh-token',
        expires_in: 3600,
        token_type: 'Bearer'
      }.to_json
    end

    before do
      stub_request(:post, "#{ENV['COGNITO_USER_POOL_SITE']}/oauth2/token")
        .to_return(status: 200, body: cognito_oauth2_token_response, headers: { 'Content-Type' => 'application/json' })

      region = ENV.fetch('COGNITO_AWS_REGION')
      user_pool_id = ENV.fetch('COGNITO_USER_POOL_ID')
      stub_request(:get, "https://cognito-idp.#{region}.amazonaws.com/#{user_pool_id}/.well-known/jwks.json")
        .to_return(status: 200,
                   body: cognito_public_keys_as_jwks.to_json,
                   headers: { 'Content-Type' => 'application/json' })
    end

    it 'logs the user in and redirects to the home page' do
      get '/auth/cognito/callback', params: { code: 'callback-code', state: state }

      expect(response).to redirect_to(homepage_path)
    end
  end
end
