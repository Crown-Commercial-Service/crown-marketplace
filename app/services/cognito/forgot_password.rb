module Cognito
  class ForgotPassword < BaseService
    include ActiveModel::Validations

    attr_reader :email, :error

    validates :email, format: { with: /\A([\w+-].?)+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i }

    def initialize(email)
      @email = email.try(:downcase)
      @error = nil
    end

    def call
      forgot_password if valid?
    rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException
      # To prevent user enumeration, continue if the email does not exist
    rescue Aws::CognitoIdentityProvider::Errors::InvalidParameterException
      errors.add(:email, :invalid)
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      errors.add(:base, e.message)
    end

    def success?
      errors.none?
    end

    private

    def forgot_password
      client.forgot_password(client_id: ENV.fetch('COGNITO_CLIENT_ID', nil), username: email)
    end
  end
end
