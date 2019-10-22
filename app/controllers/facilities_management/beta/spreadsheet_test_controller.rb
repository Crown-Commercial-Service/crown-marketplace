require 'facilities_management/fm_buildings_data'

module FacilitiesManagement
  module Beta
    class SpreadsheetTestController < FacilitiesManagement::FrameworkController
      def index; end

      def dm_spreadsheet_download
        building_ids = Buildings.where(user_id: Base64.encode64(current_user.email)).pluck(:id)
        service_codes = FacilitiesManagement::StaticData.work_packages.map { |wp| wp['code'] }
        building_ids_with_service_codes = []

        building_ids.each { |bid| building_ids_with_service_codes << { building_id: bid, service_codes: service_codes } }
        respond_to do |format|
          format.html
          format.xlsx do
            spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new(building_ids_with_service_codes)
            spreadsheet = spreadsheet_builder.build
            render xlsx: spreadsheet.to_stream.read, filename: 'deliverable_matrix.xlsx', format: 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
          end
        end
      end
    end
  end
end
