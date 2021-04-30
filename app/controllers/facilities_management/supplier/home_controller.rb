class FacilitiesManagement::Supplier::HomeController < FacilitiesManagement::Supplier::FrameworkController
  before_action :authenticate_user!, :authorize_user, except: %i[index accessibility_statement cookie_policy cookie_settings]

  def index
    if user_signed_in?
      redirect_to facilities_management_supplier_dashboard_index_path
    else
      redirect_to facilities_management_supplier_new_user_session_path
    end
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
end
