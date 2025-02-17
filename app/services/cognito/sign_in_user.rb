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
      errors.add(:base, e.message)
      @needs_password_reset = true
    rescue Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException => e
      errors.add(:base, e.message)
      @needs_confirmation = true
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError
      errors.add(:base, :sign_in_error)
    end

    def success?
      @auth_response.present? && errors.none?
    end

    def challenge?
      @auth_response.challenge_name.present?
    end

    def cognito_uuid
      @auth_response.challenge_parameters['USER_ID_FOR_SRP']
    end

    delegate :session, to: :@auth_response

    delegate :challenge_name, to: :@auth_response

    private

    def initiate_auth
      go_then_wait do
        @auth_response = client.initiate_auth(
          client_id: ENV.fetch('COGNITO_CLIENT_ID', nil),
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
