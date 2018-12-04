module FacilitiesManagement
  class FrameworkController < ::ApplicationController
    require_permission :facilities_management
  end
end
