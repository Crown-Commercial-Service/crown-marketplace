module Cognito
  class ConfirmSignUp < BaseService
    attr_reader :email, :confirmation_code
    attr_accessor :error, :user

    def initialize(email, confirmation_code)
      @email = email
      @confirmation_code = confirmation_code
      @error = nil
    end

    def call
      confirm_sign_up
      confirm_user
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
    end

    private

    def confirm_sign_up
      @response = client.confirm_sign_up(
        client_id: ENV['COGNITO_CLIENT_ID'],
        username: email,
        confirmation_code: confirmation_code
      )
    end

    def confirm_user
      @user = User.find_by(email: email)
      @user.update(confirmed_at: Time.zone.now)
    end
  end
end
