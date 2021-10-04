module FacilitiesManagement::RM3830::Admin
  class ManagementReportCsvGenerator
    def initialize(id)
      @management_report = ManagementReport.find(id)
      @start_date = @management_report.start_date
      @end_date = @management_report.end_date
    end

    def generate
      report_csv = StringIO.new ProcurementCsvExport.call(@start_date, @end_date)
      @management_report.management_report_csv.attach(io: report_csv, filename: "procurements_data_#{created_at}_#{date_to_string(@start_date)}-#{date_to_string(@end_date)}.csv", content_type: 'text/csv')
      @management_report.complete
      @management_report.save
    end

    private

    def date_to_string(date)
      date&.in_time_zone('London')&.strftime '%Y%m%d'
    end

    def created_at
      @management_report.created_at&.in_time_zone('London')&.strftime '%Y%m%d-%H%M'
    end
  end
end
