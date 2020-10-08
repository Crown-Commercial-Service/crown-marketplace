class FacilitiesManagement::Admin::ManagementReportCsvGenerator
  def initialize(id)
    @management_report = FacilitiesManagement::Admin::ManagementReport.find(id)
  end

  def generate
    report_csv = StringIO.new ProcurementCsvExport.call(@management_report.start_date, @management_report.end_date)

    @management_report.management_report_csv.attach(io: report_csv, filename: 'procurements_data.csv', content_type: 'text/csv')
    @management_report.complete
    @management_report.save
  end
end
