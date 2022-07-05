module FacilitiesManagement
  module RM3830
    module Admin
      class UploadsController < FacilitiesManagement::Admin::UploadsController
        def spreadsheet_template
          spreadsheet_builder = SupplierFrameworkDataSpreadsheet.new
          spreadsheet_builder.build
          send_data spreadsheet_builder.to_xlsx, filename: 'RM3830 Supplier Framework Data (template).xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        end
      end
    end
  end
end
