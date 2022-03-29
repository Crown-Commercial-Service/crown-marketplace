module FacilitiesManagement
  module RM6232
    class RegistrationsController < FacilitiesManagement::RegistrationsController
      private

      def fm_access
        :fm_access
      end

      def service_after_sign_up_path
        facilities_management_rm6232_users_confirm_path
      end

      def domain_not_on_safelist_path
        facilities_management_rm6232_domain_not_on_safelist_path
      end
    end
  end
end
