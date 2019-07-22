module Cognito
  class ForgotPassword < BaseService
    attr_reader :email, :error

    def initialize(email)
      @email = email
      @error = nil
    end

    def call
      forgot_password
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
    end

    def success?
      error.nil?
    end

    private

    def forgot_password
      client.forgot_password(client_id: ENV['COGNITO_CLIENT_ID'], username: email)
    end
  end
end
