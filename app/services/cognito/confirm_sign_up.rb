module Cognito
  class ConfirmSignUp < BaseService
    include ActiveModel::Validations
    attr_reader :email, :confirmation_code
    attr_accessor :user

    validates_presence_of :confirmation_code, :email
    validates :confirmation_code,
              presence: true,
              format: { with: /\A\d+\z/, message: :invalid_format },
              length: { is: 6, message: :invalid_length }

    def initialize(email, confirmation_code)
      @email = email.try(:downcase)
      @confirmation_code = confirmation_code
      @error = nil
    end

    def call
      if valid?
        confirm_sign_up
        confirm_user
      end
    rescue Aws::CognitoIdentityProvider::Errors::NotAuthorizedException
      # We do nothing as we don't want people to be able enumerate users
      errors.add(:confirmation_code, :invalid)
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      errors.add(:confirmation_code, e.message)
    end

    def success?
      errors.empty?
    end

    private

    def confirm_sign_up
      @response = client.confirm_sign_up(
        client_id: ENV.fetch('COGNITO_CLIENT_ID', nil),
        username: email,
        confirmation_code: confirmation_code
      )
    end

    def confirm_user
      @user = User.find_for_authentication(email:)
      @user.update(confirmed_at: Time.zone.now)
    end
  end
end
