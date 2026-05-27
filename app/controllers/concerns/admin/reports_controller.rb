module Admin::ReportsController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, :authorize_user
    before_action :set_framework
    before_action :set_report, only: %i[show progress]

    helper_method :service, :reports_index_path, :reports_new_path, :reports_create_path, :reports_show_path
  end

  def index
    @reports = @framework.reports.order(created_at: :desc).page(params[:page])
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(framework: @framework, user: current_user)

    @report.assign_attributes(report_params)

    if @report.save
      redirect_to reports_show_path(@report.id)
    else
      render :new
    end
  end

  def show; end

  def progress
    render json: { import_status: @report.aasm_state }
  end

  private

  def authorize_user
    authorize! :manage, service.module_parent::Admin
  end

  def service
    @service ||= self.class.module_parent.module_parent
  end

  def set_framework
    @framework = Framework.find(params.expect(:framework))
  end

  def set_report
    @report = Report.find(params[:id] || params[:report_id])
  end

  def reports_index_path
    "#{service_path_base}/reports"
  end

  def reports_new_path
    "#{service_path_base}/reports/new"
  end

  def reports_show_path(report_id)
    "#{service_path_base}/reports/#{report_id}"
  end

  def report_params
    params.expect(
      report: %i[
        start_date_dd
        start_date_mm
        start_date_yyyy
        end_date_dd
        end_date_mm
        end_date_yyyy
      ]
    )
  end

  alias_method :reports_create_path, :reports_index_path
end
