module FacilitiesManagement
  class HomeController < FacilitiesManagement::FrameworkController
    before_action :authenticate_user!, :authorize_user, :redirect_if_unrecognised_framework, except: %i[not_permitted accessibility_statement cookie_policy cookie_settings framework unrecognised_framework]

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
      redirect_to facilities_management_rm3830_path
    end

    def unrecognised_framework; end
  end
end
