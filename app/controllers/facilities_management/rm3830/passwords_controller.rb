module FacilitiesManagement
  module RM3830
    class PasswordsController < FacilitiesManagement::PasswordsController
      protected

      def new_password_path
        facilities_management_rm3830_new_user_password_path
      end

      def after_password_reset_path
        facilities_management_rm3830_password_reset_success_path
      end

      def after_request_password_path
        facilities_management_rm3830_edit_user_password_path
      end
    end
  end
end
