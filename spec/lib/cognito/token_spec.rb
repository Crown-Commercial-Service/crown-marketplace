require 'rails_helper'

RSpec.describe Cognito::Token do
  describe '#verify!' do
    it 'returns self when the token is valid' do
      user_pool = Cognito::UserPool.new('aws-region', 'user-pool-id')
      jwt = JSON::JWT.new(iss: user_pool.idp_url)
      token = described_class.new(jwt)
      expect(token.verify!(user_pool)).to eq(token)
    end

    it 'raises exception when issuer does not match user pool idp url' do
      user_pool = Cognito::UserPool.new('aws-region', 'user-pool-id')
      jwt = JSON::JWT.new(iss: 'made-up-url')
      token = described_class.new(jwt)
      expect { token.verify!(user_pool) }.to raise_error(Cognito::Token::VerificationFailure, 'issuer is invalid')
    end
  end

  describe '#subject' do
    it 'returns the subject of the token' do
      jwt = JSON::JWT.new(sub: 'token-subject')
      token = described_class.new(jwt)
      expect(token.subject).to eq('token-subject')
    end
  end
end
