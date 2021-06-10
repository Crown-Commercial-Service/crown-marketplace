module FacilitiesManagement
  class HomeController < FacilitiesManagement::FrameworkController
    before_action :authenticate_user!, :authorize_user, except: %i[index not_permitted accessibility_statement cookie_policy cookie_settings]

    def index; end

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
      if params[:framework] == 'RM6870'
        redirect_to facilities_management_rm6870_path
      else
        redirect_to facilities_management_rm3830_path
      end
    end
  end
end
