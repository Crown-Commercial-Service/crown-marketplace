module FacilitiesManagement
  module Admin
    class ManagementReportsController < FacilitiesManagement::Admin::FrameworkController
      before_action :set_management_report, only: %i[show progress]

      helper_method :show_path, :new_path, :index_path

      def index
        @management_reports = service::ManagementReport.order(created_at: :desc).page(params[:page])
      end

      def show; end

      def new
        @management_report = service::ManagementReport.new
      end

      def create
        @management_report = service::ManagementReport.new(user: current_user)

        @management_report.assign_attributes(management_report_params)

        if @management_report.save
          redirect_to show_path(@management_report.id)
        else
          render :new
        end
      end

      def progress
        render json: { import_status: @management_report.aasm_state }
      end

      private

      def service
        @service ||= self.class.module_parent
      end

      def set_management_report
        @management_report = service::ManagementReport.find(params[:id])
      end

      def index_path
        "/facilities-management/#{params[:framework]}/admin/management-reports"
      end

      def new_path
        "/facilities-management/#{params[:framework]}/admin/management-reports/new"
      end

      def show_path(management_report_id)
        "/facilities-management/#{params[:framework]}/admin/management-reports/#{management_report_id}"
      end

      def management_report_params
        params.expect(
          @management_report.model_name.param_key => %i[
            start_date_dd
            start_date_mm
            start_date_yyyy
            end_date_dd
            end_date_mm
            end_date_yyyy
          ]
        )
      end
    end
  end
end
