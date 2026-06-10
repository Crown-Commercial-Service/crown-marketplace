module FacilitiesManagement
  module RM6378
    module Admin
      class ReportsController < FacilitiesManagement::Admin::FrameworkController
        include ::Admin::ReportActions
      end
    end
  end
end
