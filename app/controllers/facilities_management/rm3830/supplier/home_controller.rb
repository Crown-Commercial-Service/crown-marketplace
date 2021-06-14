class FacilitiesManagement::RM3830::Supplier::HomeController < FacilitiesManagement::Supplier::FrameworkController
  before_action :authenticate_user!, :authorize_user, except: %i[index]

  def index
    if user_signed_in?
      redirect_to facilities_management_rm3830_supplier_dashboard_index_path
    else
      redirect_to facilities_management_rm3830_supplier_new_user_session_path
    end
  end
end
