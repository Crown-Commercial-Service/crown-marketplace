class FacilitiesManagement::Supplier::HomeController < FacilitiesManagement::Supplier::FrameworkController
  before_action :authenticate_user!, :authorize_user, :raise_if_unrecognised_framework, except: %i[accessibility_statement cookie_policy cookie_settings framework]

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
    redirect_to facilities_management_rm3830_supplier_path
  end
end
