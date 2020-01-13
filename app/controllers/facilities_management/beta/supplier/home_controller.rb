module FacilitiesManagement
  module Beta
    module Supplier
      class HomeController < FrameworkController
        before_action :authenticate_user!, except: :index
        before_action :authorize_user, except: :index

        def index
          if user_signed_in?
            redirect_to facilities_management_beta_supplier_supplier_account_dashboard_path
          else
            redirect_to facilities_management_beta_supplier_new_user_session_path
          end
        end
      end
    end
  end
end
