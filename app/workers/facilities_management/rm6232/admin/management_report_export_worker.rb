module FacilitiesManagement
  module RM6232
    module Admin
      class ManagementReportExportWorker
        include Sidekiq::Worker
        sidekiq_options queue: 'fm', retry: false

        def perform
          report_csv = StringIO.new(
            ProcurementCsvExport.call(
              START_DATE,
              Time.now.in_time_zone('London')
            )
          )

          file_stream = Zip::OutputStream.write_buffer do |zip|
            zip.put_next_entry 'facilities-management-rm6232-report.csv'
            zip.print report_csv.read
          end

          file_stream.rewind

          update_the_management_report(file_stream)
        rescue StandardError => e
          Rollbar.log('error', e)

          logger.error e.message
        end

        private

        START_DATE = Time.new(2022, 7, 18).in_time_zone('London').freeze

        def management_report_s3_object
          @management_report_s3_object ||= Aws::S3::Resource.new(region: ENV.fetch('COGNITO_AWS_REGION', nil)).bucket(ENV.fetch('CCS_APP_API_DATA_BUCKET', nil)).object(ENV.fetch('MANAGEMENT_REPORT_KEY', nil))
        end

        def update_the_management_report(file_stream)
          management_report_s3_object.put({ body: file_stream.read })
        end
      end
    end
  end
end
