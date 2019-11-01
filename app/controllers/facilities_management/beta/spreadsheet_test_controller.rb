require 'facilities_management/fm_buildings_data'

module FacilitiesManagement
  module Beta
    class SpreadsheetTestController < FacilitiesManagement::FrameworkController
      def index; end

      def dm_spreadsheet_download
        assign_building_ids_and_service_codes

        building_ids_with_service_codes = []

        @building_ids.each_with_index do |bid, index|
          building_ids_with_service_codes << { building_id: bid, service_codes: @first_half_service_codes } if index.even?
          building_ids_with_service_codes << { building_id: bid, service_codes: @second_half_service_codes } if index.odd?
        end

        respond_to do |format|
          format.html
          format.xlsx do
            spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new(building_ids_with_service_codes)
            spreadsheet = spreadsheet_builder.build
            render xlsx: spreadsheet.to_stream.read, filename: 'deliverable_matrix', format: 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
          end
        end
      end

      private

      def assign_building_ids_and_service_codes
        @building_ids = Buildings.where(user_id: Base64.encode64(current_user.email)).pluck(:id)
        service_codes = FacilitiesManagement::StaticData.work_packages.map { |wp| wp['code'] }
        @first_half_service_codes, @second_half_service_codes = service_codes.each_slice((service_codes.size / 2.0).round).to_a
      end
    end
  end
end
