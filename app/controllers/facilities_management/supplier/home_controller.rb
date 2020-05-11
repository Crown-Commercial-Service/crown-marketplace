class FacilitiesManagement::Supplier::HomeController < FacilitiesManagement::Supplier::FrameworkController
  before_action :authenticate_user!, except: :index
  before_action :authorize_user, except: :index

  def index
    if user_signed_in?
      redirect_to facilities_management_supplier_dashboard_index_path
    else
      redirect_to facilities_management_supplier_new_user_session_path
    end
  end
end
