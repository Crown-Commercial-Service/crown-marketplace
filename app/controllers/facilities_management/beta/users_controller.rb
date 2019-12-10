module FacilitiesManagement
  module Beta
    class UsersController < Base::UsersController
      private

      def new_challenge_path
        facilities_management_beta_users_challenge_path(challenge_name: @challenge.new_challenge_name, session: @challenge.new_session, username: params[:username])
      end

      def after_sign_in_path_for(resource)
        return edit_facilities_management_beta_buyer_detail_path(FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user)) if current_user.fm_buyer_details_incomplete?

        stored_location_for(resource) || facilities_management_beta_path
      end

      def confirm_user_registration_path
        facilities_management_beta_users_confirm_path(email: params[:email])
      end
    end
  end
end
