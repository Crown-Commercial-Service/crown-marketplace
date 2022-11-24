module Cognito
  class SignInUser < BaseService
    include ActiveModel::Validations
    attr_reader :email, :password, :cookies_disabled
    attr_accessor :error, :needs_password_reset, :needs_confirmation

    validates_presence_of :email, :password
    validates_format_of :email, with: /\A[^\s^@]+@[^\s^@]+\z/, message: :blank
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
    rescue Aws::CognitoIdentityProvider::Errors::PasswordResetRequiredException => e
      @error = e.message
      errors.add(:base, e.message)
      @needs_password_reset = true
    rescue Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException => e
      @error = e.message
      errors.add(:base, e.message)
      @needs_confirmation = true
    rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException
      @error = I18n.t('facilities_management.users.sign_in_error')
      errors.add(:base, @error)
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError
      @error = I18n.t('facilities_management.users.sign_in_error')
      errors.add(:base, @error)
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
      go_then_wait do
        @auth_response = client.initiate_auth(
          client_id: ENV['COGNITO_CLIENT_ID'],
          auth_flow: 'USER_PASSWORD_AUTH',
          auth_parameters: {
            'USERNAME' => email,
            'PASSWORD' => password
          }
        )
      end
    end

    def cookies_should_be_enabled
      errors.add(:base, :cookies_disabled) if @cookies_disabled
    end

    # This should keep the response times for attempting to log in with a fake or valid an account around the same length
    def go_then_wait
      finish_time = Time.now.in_time_zone('London') + MINIMUM_WAIT_TIME.second

      yield
    ensure
      sleep (finish_time - Time.now.in_time_zone('London')).clamp(0, MINIMUM_WAIT_TIME).seconds
    end

    MINIMUM_WAIT_TIME = 1
  end
end
