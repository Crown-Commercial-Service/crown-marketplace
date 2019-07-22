module SupplyTeachers
  module Admin
    class PasswordsController < Base::PasswordsController
      protected

      def new_password_path
        supply_teachers_admin_new_user_password_path
      end

      def edit_password_path
        supply_teachers_admin_edit_user_password_path
      end

      def after_password_reset_path
        supply_teachers_admin_password_reset_success_path
      end

      def after_request_password_path
        supply_teachers_admin_edit_user_password_path(email: params[:email])
      end
    end
  end
end
