module SupplyTeachers
  class FrameworkController < ::ApplicationController
    require_permission :supply_teachers
  end
end
