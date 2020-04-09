module FacilitiesManagement
  module Beta
    module Admin
      class ExportController < ::ApplicationController
        before_action :authenticate_user!
        before_action :authorize_user

        def start; end

        def export
          # assign_building_ids_and_service_codes

          # building_ids_with_service_codes = []

          # @building_ids.each_with_index do |bid, index|
          #   building_ids_with_service_codes << { building_id: bid, service_codes: @first_half_service_codes } if index.even?
          #   building_ids_with_service_codes << { building_id: bid, service_codes: @second_half_service_codes } if index.odd?
          # end

          # respond_to do |format|
          #   format.html
          #   format.xlsx do
          #     spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new(building_ids_with_service_codes)
          #     spreadsheet = spreadsheet_builder.build
          #     render xlsx: spreadsheet.to_stream.read, filename: 'deliverable_matrix', format: 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
          #   end
          # end
          render :download
        end

        protected

        def authorize_user
          authorize! :manage, FacilitiesManagement::Beta::Admin
        end
      end
    end
  end
end