require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class CognitoAuthenticatable < Authenticatable
      def authenticate!
        return unless params[:user]

        find_or_create_user
      end

      private

      def email
        params[:user][:email]
      end

      def password
        params[:user][:password]
      end

      def access?(tool)
        params[:controller].split('/').first == tool
      end

      def find_or_create_user
        user = User.find_for_authentication(email:)
        user ? update_if_needed(user) : create_user_in_database
      end

      def update_if_needed(user)
        Cognito::UpdateUser.call(user)
        success!(user)
      end

      def create_user_in_database
        resp = Cognito::CreateUserFromCognito.call(email)

        if resp.success?
          success!(resp.user)
        else
          fail!(resp.error)
        end
      end
    end
  end
end
