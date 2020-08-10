module FacilitiesManagement
  module Procurements
    class SpreadsheetImportsController < FacilitiesManagement::FrameworkController
      include FacilitiesManagement::ControllerLayoutHelper

      def new
        @spreadsheet_import = FacilitiesManagement::SpreadsheetImport.new(facilities_management_procurement_id: params[:procurement_id])
      end

      def create
        @spreadsheet_import = SpreadsheetImport.new(spreadsheet_import_params)
        if @spreadsheet_import.save
          FacilitiesManagement::SpreadsheetImporter.new(@spreadsheet_import).import_data # TODO: This will become a background job
          redirect_to facilities_management_procurement_spreadsheet_import_path(procurement_id: @spreadsheet_import.procurement.id, id: @spreadsheet_import.id)
        else
          @spreadsheet_import.fail!
          render :new
        end
      end

      def show
        @spreadsheet_import = SpreadsheetImport.find(params[:id])
        @procurement = FacilitiesManagement::Procurement.find(params[:procurement_id])
      end

      private

      def spreadsheet_import_params
        params.require(:facilities_management_spreadsheet_import).permit(:spreadsheet_file, :facilities_management_procurement_id)
      end
    end
  end
end
