module FacilitiesManagement
  module Beta
    module Admin
      class ManagementReportController < FacilitiesManagement::Beta::FrameworkController

        def index
          @management_report = FacilitiesManagement::Admin::ManagementReport.new(nil,nil)
        end
      end
    end
  end
end
