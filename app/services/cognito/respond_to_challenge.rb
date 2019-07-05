module Cognito
  class RespondToChallenge < BaseService
    include ActiveModel::Validations
    attr_reader :challenge_name, :username, :session, :new_password, :new_password_confirmation, :access_code, :roles

    validates :new_password,
              presence: true,
              confirmation: { case_sensitive: true },
              length: { within: 8..200 },
              if: :new_password_challenge?
    validates_presence_of :new_password_confirmation, if: :new_password_challenge?
    validates_format_of :new_password, with: /(?=.*[A-Z])/, message: :invalid_no_capitals, if: :new_password_challenge?
    validates_format_of :new_password, with: /(?=.*\W)/, message: :invalid_no_symbol, if: :new_password_challenge?

    def initialize(challenge_name, username, session, **options)
      @challenge_name = challenge_name
      @session = session
      @new_password = options[:new_password]
      @new_password_confirmation = options[:new_password_confirmation]
      @access_code = options[:access_code]
      @username = username
      @error = nil
    end

    def call
      respond_to_challenge
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      errors.add(:base, e.message)
    end

    def success?
      errors.none?
    end

    def new_challenge_name
      @response.challenge_name
    end

    def challenge?
      @response.challenge_name.present?
    end

    def cognito_uuid
      @response.challenge_parameters['USER_ID_FOR_SRP']
    end

    def new_session
      @response.session
    end

    private

    def new_password_challenge?
      challenge_name == 'NEW_PASSWORD_REQUIRED'
    end

    def sms_mfa_challenge?
      challenge_name == 'SMS_MFA'
    end

    def respond_to_challenge
      if new_password_challenge?
        if valid?
          @response = client.respond_to_auth_challenge(client_id: ENV['COGNITO_CLIENT_ID'], challenge_name: 'NEW_PASSWORD_REQUIRED', session: session, challenge_responses: { 'NEW_PASSWORD' => new_password, 'USERNAME' => username })
          Cognito::CreateUserFromCognito.call(username) if User.find_by(cognito_uuid: username).nil?
        end
      elsif sms_mfa_challenge?
        @response = client.respond_to_auth_challenge(client_id: ENV['COGNITO_CLIENT_ID'], challenge_name: 'SMS_MFA', session: session, challenge_responses: { 'SMS_MFA_CODE' => access_code, 'USERNAME' => username })
      end
    end
  end
end
