module FacilitiesManagement
  module Beta
    module Admin
      class ManagementReportController < FacilitiesManagement::Beta::FrameworkController
        def index
          @management_report = FacilitiesManagement::Admin::ManagementReport.new(nil, nil)
        end

        def update
          @management_report = FacilitiesManagement::Admin::ManagementReport.new(nil, nil)
          @management_report.assign_attributes(management_report_params)
          return nil if @management_report.valid?

          render :index
        end

        private

        def management_report_params
          params.require(:facilities_management_admin_management_report)
                .permit(
                  :start_date_dd,
                  :start_date_mm,
                  :start_date_yyyy,
                  :end_date_dd,
                  :end_date_mm,
                  :end_date_yyyy
                )
        end
      end
    end
  end
end
