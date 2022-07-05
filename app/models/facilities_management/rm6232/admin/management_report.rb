module FacilitiesManagement
  module RM6232
    module Admin
      class ManagementReport < FacilitiesManagement::Admin::ManagementReport
        belongs_to :user, inverse_of: :rm6232_management_reports

        acts_as_gov_uk_date :start_date, :end_date, error_clash_behaviour: :omit_gov_uk_date_field_error

        private

        def generate_report_csv
          # ManagementReportWorker.perform_async(id) unless management_report_csv.attached?
        end
      end
    end
  end
end
