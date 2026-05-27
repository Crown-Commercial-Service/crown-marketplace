module Admin::ReportsHelper
  def upload_status_tag(status)
    case status
    when 'completed'
      [t('shared.admin.reports.show.report_status.complete')]
    when 'failed'
      [t('shared.admin.reports.show.report_status.failed'), :red]
    else
      [t('shared.admin.reports.show.report_status.in_progress'), :grey]
    end
  end
end
