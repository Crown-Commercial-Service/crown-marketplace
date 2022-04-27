module FacilitiesManagement
  module Admin
    class HomeController < FacilitiesManagement::Admin::FrameworkController
      before_action :authenticate_user!, :authorize_user, :raise_if_unrecognised_framework, except: %i[not_permitted accessibility_statement cookie_policy cookie_settings framework index]

      def not_permitted
        render 'home/not_permitted', layout: 'error'
      end

      def accessibility_statement
        render 'home/accessibility_statement'
      end

      def cookie_policy
        render 'home/cookie_policy'
      end

      def cookie_settings
        render 'home/cookie_settings'
      end

      def framework
        redirect_to facilities_management_admin_index_path(FacilitiesManagement::Framework.default_framework)
      end

      def index
        raise_if_unrecognised_framework
      end
    end
  end
end
