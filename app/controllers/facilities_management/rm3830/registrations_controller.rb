module FacilitiesManagement
  module RM3830
    class RegistrationsController < Base::RegistrationsController
      private

      def fm_access
        :fm_access
      end

      def service_after_sign_up_path
        facilities_management_rm3830_users_confirm_path
      end

      def domain_not_on_safelist_path
        facilities_management_rm3830_domain_not_on_safelist_path
      end
    end
  end
end
