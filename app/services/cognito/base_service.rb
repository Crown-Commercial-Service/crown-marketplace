module Cognito
  class BaseService
    attr_accessor :error

    # Use Class.call(args) rather than Class.new(args).call
    def self.call(...)
      resp = new(...)
      resp.call
      resp
    end

    def success?
      @error.nil?
    end

    private

    def client
      @client ||= Aws::CognitoIdentityProvider::Client.new(region: ENV.fetch('COGNITO_AWS_REGION', nil))
    end
  end
end
