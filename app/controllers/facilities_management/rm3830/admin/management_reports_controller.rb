module FacilitiesManagement
  module RM3830
    module Admin
      class ManagementReportsController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_management_report, only: %i[show status]

        def new
          @management_report = ManagementReport.new
        end

        def show; end

        def create
          @management_report = current_user.management_reports.build(management_report_params)

          if @management_report.save
            redirect_to facilities_management_rm3830_admin_management_report_path(@management_report)
          else
            render :new
          end
        end

        def status
          render json: { status: @management_report.aasm_state }
        end

        private

        def set_management_report
          @management_report = ManagementReport.find(params[:id] || params[:management_report_id])
        end

        def management_report_params
          params.require(:facilities_management_rm3830_admin_management_report)
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
