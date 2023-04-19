module FacilitiesManagement
  module RM3830
    module Admin
      class UploadsController < FacilitiesManagement::Admin::UploadsController
        before_action :set_framework_has_expired
        # rubocop:disable Rails/LexicallyScopedActionFilter
        before_action :redirect_if_framework_has_expired, only: %i[new create]
        # rubocop:enable Rails/LexicallyScopedActionFilter

        def spreadsheet_template
          spreadsheet_builder = SupplierFrameworkDataSpreadsheet.new
          spreadsheet_builder.build
          send_data spreadsheet_builder.to_xlsx, filename: 'RM3830 Supplier Framework Data (template).xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        end

        private

        def redirect_if_framework_has_expired
          redirect_to facilities_management_rm3830_admin_uploads_path if @framework_has_expired
        end
      end
    end
  end
end
