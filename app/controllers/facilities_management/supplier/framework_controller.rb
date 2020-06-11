class FacilitiesManagement::Supplier::FrameworkController < ::ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  protected

  def authorize_user
    authorize! :read, FacilitiesManagement::Supplier
  end
end
