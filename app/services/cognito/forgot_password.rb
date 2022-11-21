module Cognito
  class ForgotPassword < BaseService
    include ActiveModel::Validations
    attr_reader :email, :error

    validates :email, format: { with: /\A([\w+-].?)+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i }

    def initialize(email)
      @email = email
      @error = nil
    end

    def call
      if valid?
        forgot_password
      else
        @error = I18n.t('cognito/cog_forgot_password_request.attributes.please_enter_a_valid_email_address')
      end
    rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException
      @error = nil
    rescue Aws::CognitoIdentityProvider::Errors::InvalidParameterException
      @error = I18n.t('cognito/cog_forgot_password_request.attributes.please_enter_a_valid_email_address')
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
