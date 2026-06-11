class ReportCsvGenerator
  def initialize(id)
    @report = Report.find(id)
    @report_generator_class = "#{@report.framework.service.camelize}::#{@report.framework.id}::Admin::ReportExport".constantize
  end

  def generate
    @report.report_csv.attach(
      io: StringIO.new("\xEF\xBB\xBF#{@report_generator_class.call(@report)}"),
      filename: "#{@report.framework.service}_#{@report.framework.id.downcase}_#{created_at}_#{date_to_string(@report.start_date)}-#{date_to_string(@report.end_date)}.csv",
      content_type: 'text/csv'
    )
    @report.complete
  rescue StandardError => e
    Rollbar.log('error', e)
    @report.fail
  ensure
    @report.save
  end

  def date_to_string(date)
    date.in_time_zone('London')&.strftime '%Y%m%d'
  end

  def created_at
    @report.created_at.in_time_zone('London')&.strftime '%Y%m%d-%H%M'
  end
end
