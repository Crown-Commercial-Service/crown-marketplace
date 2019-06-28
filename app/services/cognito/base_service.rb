module Cognito
  class BaseService
    attr_accessor :error

    # Use Class.call(args) rather than Class.new(args).call
    def self.call(*args, &block)
      resp = new(*args, &block)
      resp.call
      resp
    end

    def success?
      @error.nil?
    end

    private

    def client
      @client ||= Aws::CognitoIdentityProvider::Client.new(region: ENV['COGNITO_AWS_REGION'])
    end
  end
end
