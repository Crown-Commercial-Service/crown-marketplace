module FacilitiesManagement
  module RM6378
    module Admin
      class DashboardController < FacilitiesManagement::Admin::FrameworkController
        include SharedPagesConcern
        include ::Admin::DashboardController
      end
    end
  end
end
