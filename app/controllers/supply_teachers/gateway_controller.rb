module SupplyTeachers
  class GatewayController < ApplicationController
    require_permission :none, only: :index

    def index
      redirect_to supply_teachers_path if logged_in?
    end
  end
end
