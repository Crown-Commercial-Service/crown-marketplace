module SupplyTeachers
  class HomeController < ApplicationController
    before_action { require_framework_permission :supply_teachers }

    def index; end
  end
end
