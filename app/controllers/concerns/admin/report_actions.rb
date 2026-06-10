module Admin::ReportActions
  extend ActiveSupport::Concern

  include Admin::SupplierPathsConcern

  included do
    before_action :authenticate_user!, :authorize_user
    before_action :set_framework
    before_action :set_reports, only: %i[index]
    before_action :set_report, only: %i[show progress]

    helper_method :service
  end

  def index
    render template: 'shared/admin/reports/index'
  end

  def new
    @report = Report.new

    render template: 'shared/admin/reports/new'
  end

  def create
    @report = Report.new(framework: @framework, user: current_user)

    @report.assign_attributes(report_params)

    if @report.save
      redirect_to user_reports_show_path(@report.id)
    else
      render template: 'shared/admin/reports/new'
    end
  end

  def show
    render template: 'shared/admin/reports/show'
  end

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

  def set_reports
    @reports = @framework.reports.order(created_at: :desc).page(params[:page])
  end

  def set_report
    @report = Report.find(params[:id] || params[:report_id])
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
end
