module Cognito
  class ForgotPassword < BaseService
    attr_reader :email, :error

    def initialize(email)
      @email = email
      @error = nil
    end

    def call
      forgot_password
    rescue Aws::CognitoIdentityProvider::Errors::InvalidParameterException
      @error = I18n.t('activemodel.errors.models.ccs_patterns/home/cog_forgot_password_request.attributes.please_enter_a_valid_email_address')
    rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException
      @error = nil
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
