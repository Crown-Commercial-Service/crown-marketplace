module SupplyTeachers
  class GatewayController < FrameworkController
    require_permission :none, only: :index

    def index
      @cognito_enabled =
        Marketplace.supply_teachers_cognito_enabled? ||
        params[:cognito_enabled]
      redirect_to supply_teachers_path if logged_in?
    end
  end
end
