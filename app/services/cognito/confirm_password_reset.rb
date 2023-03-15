module Cognito
  class ConfirmPasswordReset < BaseService
    include ActiveModel::Validations
    attr_reader :email, :password, :password_confirmation, :confirmation_code

    validates :password,
              presence: true,
              confirmation: { case_sensitive: true },
              length: { within: 8..200 }

    validates_presence_of :password_confirmation, :confirmation_code
    validates_format_of :password, with: /(?=.*[A-Z])/, message: :invalid_no_capitals
    validates_format_of :password, with: /(?=.*\W)/, message: :invalid_no_symbol
    validates_format_of :password, with: /(?=.*[0-9])/, message: :invalid_no_number

    def initialize(email, password, password_confirmation, confirmation_code)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
      @confirmation_code = confirmation_code
    end

    def call
      if valid?
        create_user_if_needed
        confirm_forgot_password
      end
    rescue Aws::CognitoIdentityProvider::Errors::CodeMismatchException => e
      errors.add(:confirmation_code, e.message)
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      errors.add(:base, e.message)
    end

    def success?
      errors.none?
    end

    private

    def confirm_forgot_password
      @response = client.confirm_forgot_password(
        client_id: ENV.fetch('COGNITO_CLIENT_ID', nil),
        username: email,
        password: password,
        confirmation_code: confirmation_code
      )
    end

    def create_user_if_needed
      user = User.find_for_authentication(email:)
      return user if user

      resp = CreateUserFromCognito.call(email)
      if resp.success?
        resp.user
      else
        errors.add(:base, I18n.t('activemodel.errors.models.cognito/confirm_password_reset.user_not_found'))
      end
    end
  end
end
