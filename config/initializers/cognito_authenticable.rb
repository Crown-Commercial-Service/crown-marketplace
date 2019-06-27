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
        user = User.find_by(email: email)
        user ? update_if_needed(user) : create_user_in_database
      end

      def update_if_needed(user)
        # TODO: update user if details on cognito changed (e.g. was added to new group)
        success!(user)
      end

      def create_user_in_database
        user = Cognito::CreateUserFromCognito.call(email).user
        if user.try(:valid?)
          success!(user)
        else
          fail!('Failed to create user.')
        end
      end
    end
  end
end
