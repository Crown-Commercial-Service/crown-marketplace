require 'facilities_management/buyer_details'

module FacilitiesManagement
  module Beta
    class SessionsController < Base::SessionsController
      protected

      def challenge_path
        facilities_management_beta_users_challenge_path(challenge_name: @result.challenge_name, session: @result.session, username: @result.cognito_uuid)
      end

      def after_sign_in_path_for(resource)
        buyer_service = BuyerDetails.new
        return facilities_management_beta_buyer_details_path if buyer_service.buyer_details_incomplete? current_user

        stored_location_for(resource) || facilities_management_beta_path
      end

      def after_sign_out_path_for(_resource)
        facilities_management_beta_path
      end

      def new_session_path
        facilities_management_beta_new_user_session_path
      end

      def confirm_forgot_password_path(username)
        facilities_management_beta_edit_user_password_path(username: username)
      end

      def confirm_email_path(email)
        facilities_management_beta_users_confirm_path(email: email)
      end
    end
  end
end
