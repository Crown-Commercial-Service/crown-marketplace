require 'rails_helper'

RSpec.describe Cognito::Token do
  describe '#verify!' do
    let(:user_pool) { Cognito::UserPool.new('aws-region', 'user-pool-id', 'app-client-id') }
    let(:valid_jwt) do
      JSON::JWT.new(
        iss: user_pool.idp_url,
        exp: 5.minutes.from_now.to_i,
        aud: user_pool.app_client_id
      )
    end

    it 'returns self when the token is valid' do
      token = described_class.new(valid_jwt)
      expect(token.verify!(user_pool)).to eq(token)
    end

    it 'raises exception when issuer does not match user pool idp url' do
      jwt = valid_jwt
      jwt[:iss] = 'made-up-url'
      token = described_class.new(jwt)
      expect { token.verify!(user_pool) }.to raise_error(Cognito::Token::VerificationFailure, 'issuer is invalid')
    end

    it 'raises exception when expiry time is in the past' do
      jwt = valid_jwt
      jwt[:exp] = 5.minutes.ago.to_i
      token = described_class.new(jwt)
      expect { token.verify!(user_pool) }.to raise_error(Cognito::Token::VerificationFailure, 'token has expired')
    end

    it 'raises exception when audience does not match user pool client id' do
      jwt = valid_jwt
      jwt[:aud] = 'made-up-audience'
      token = described_class.new(jwt)
      expect { token.verify!(user_pool) }.to raise_error(Cognito::Token::VerificationFailure, 'audience is invalid')
    end
  end

  describe '#subject' do
    it 'returns the subject of the token' do
      jwt = JSON::JWT.new(sub: 'token-subject')
      token = described_class.new(jwt)
      expect(token.subject).to eq('token-subject')
    end
  end

  describe '#email' do
    it 'returns the email of the token' do
      jwt = JSON::JWT.new(email: 'user-email')
      token = described_class.new(jwt)
      expect(token.email).to eq('user-email')
    end
  end
end
