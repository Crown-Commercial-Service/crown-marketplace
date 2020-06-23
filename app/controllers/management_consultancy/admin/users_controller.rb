module ManagementConsultancy
  module Admin
    class UsersController < Base::UsersController
      private

      def new_challenge_path
        cookies[:session] = @challenge.new_session
        management_consultancy_admin_users_challenge_path(challenge_name: @challenge.new_challenge_name, username: params[:username])
      end

      def after_sign_in_path_for(resource)
        stored_location_for(resource) || management_consultancy_admin_uploads_path
      end
    end
  end
end
