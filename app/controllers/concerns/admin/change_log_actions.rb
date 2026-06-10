module Admin::ChangeLogActions
  extend ActiveSupport::Concern

  include Admin::SupplierPathsConcern

  included do
    before_action :authenticate_user!, :authorize_user
    before_action :set_change_logs, only: %i[index]
    before_action :set_change_log, only: %i[show]

    helper_method :service
  end

  def index
    respond_to do |format|
      format.html { render template: 'shared/admin/change_logs/index' }
      format.csv do
        send_data "\xEF\xBB\xBF#{ChangeLog::CsvGenerator.new(params[:framework], helpers).generate_csv}", filename: t('shared.admin.change_logs.index.change_lot_filename', service_name: t("#{service.module_parent.to_s.underscore}.service_name"), framework: params[:framework], generation_time: Time.now.in_time_zone('London').strftime('%d_%m_%Y %H_%M').squish), type: 'text/csv'
      end
    end
  end

  def show
    render template: 'shared/admin/change_logs/show'
  end

  private

  def authorize_user
    authorize! :manage, service.module_parent::Admin
  end

  def set_change_logs
    @change_logs = ChangeLog.where(framework_id: params[:framework]).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def set_change_log
    @change_log = ChangeLog.where(framework_id: params.expect(:framework)).find(params.expect(:id))
  end

  def service
    @service ||= self.class.module_parent.module_parent
  end
end
