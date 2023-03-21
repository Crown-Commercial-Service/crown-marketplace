class FacilitiesManagement::Supplier::HomeController < FacilitiesManagement::Supplier::FrameworkController
  before_action :authenticate_user!, :authorize_user, :raise_if_not_live_framework, except: :framework

  def framework
    redirect_to facilities_management_rm3830_supplier_path
  end
end
