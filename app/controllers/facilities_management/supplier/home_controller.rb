class FacilitiesManagement::Supplier::HomeController < FacilitiesManagement::Supplier::FrameworkController
  before_action :authenticate_user!, except: %i[index accessibility_statement cookies]
  before_action :authorize_user, except: %i[index accessibility_statement cookies]

  def index
    if user_signed_in?
      redirect_to facilities_management_supplier_dashboard_index_path
    else
      redirect_to facilities_management_supplier_new_user_session_path
    end
  end

  def accessibility_statement
    render 'facilities_management/home/accessibility_statement'
  end

  def cookies
    render 'facilities_management/home/cookies'
  end
end
