module Cognito
  class SignInUser < BaseService
    include ActiveModel::Validations
    attr_reader :email, :password, :cookies_disabled
    attr_accessor :error, :needs_password_reset, :needs_confirmation

    validates_presence_of :email, :password
    validate :cookies_should_be_enabled

    def initialize(email, password, cookies_disabled)
      @email = email.try(:downcase)
      @password = password
      @error = nil
      @needs_password_reset = false
      @cookies_disabled = cookies_disabled
    end

    def call
      initiate_auth if valid?
    rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException
      @error = I18n.t('activemodel.errors.models.user.incorrect_username_or_password')
      errors.add(:base, @error)
    rescue Aws::CognitoIdentityProvider::Errors::PasswordResetRequiredException => e
      @error = e.message
      errors.add(:base, e.message)
      @needs_password_reset = true
    rescue Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException => e
      @error = e.message
      errors.add(:base, e.message)
      @needs_confirmation = true
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
      errors.add(:base, e.message)
    end

    def success?
      @auth_response.present? && @error.nil?
    end

    def challenge?
      @auth_response.challenge_name.present?
    end

    def cognito_uuid
      @auth_response.challenge_parameters['USER_ID_FOR_SRP']
    end

    def session
      @auth_response.session
    end

    def challenge_name
      @auth_response.challenge_name
    end

    private

    def initiate_auth
      @auth_response = client.initiate_auth(
        client_id: ENV['COGNITO_CLIENT_ID'],
        auth_flow: 'USER_PASSWORD_AUTH',
        auth_parameters: {
          'USERNAME' => email,
          'PASSWORD' => password
        }
      )
    end

    def cookies_should_be_enabled
      errors.add(:base, :cookies_disabled) if @cookies_disabled
    end
  end
end
