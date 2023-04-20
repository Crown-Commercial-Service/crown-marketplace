module Cognito
  class ResendConfirmationCode < BaseService
    attr_reader :email
    attr_accessor :error

    def initialize(email)
      @email = email.try(:downcase)
      @error = nil
    end

    def call
      client.resend_confirmation_code(client_id: ENV.fetch('COGNITO_CLIENT_ID', nil), username: username)
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
    end

    def success?
      @error.nil?
    end

    private

    def username
      User.find_for_authentication(email:).cognito_uuid
    end
  end
end
