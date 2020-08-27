module FacilitiesManagement
  module Procurements
    class SpreadsheetImportsController < FacilitiesManagement::FrameworkController
      include FacilitiesManagement::ControllerLayoutHelper
      before_action :set_procurement
      before_action :authorize_user
      before_action :redirect_to_requirements

      def new
        @spreadsheet_import = FacilitiesManagement::SpreadsheetImport.new(facilities_management_procurement_id: params[:procurement_id])
      end

      def create
        @procurement.remove_existing_spreadsheet_import
        @spreadsheet_import = SpreadsheetImport.new(spreadsheet_import_params)
        if @spreadsheet_import.save(context: :upload)
          @spreadsheet_import.start_import!
          redirect_to facilities_management_procurement_spreadsheet_import_path(procurement_id: @spreadsheet_import.procurement.id, id: @spreadsheet_import.id)
        else
          @spreadsheet_import.remove_spreadsheet_file
          render :new
        end
      end

      def show
        @spreadsheet_import = SpreadsheetImport.find(params[:id])
      end

      private

      def set_procurement
        @procurement = FacilitiesManagement::Procurement.find(params[:procurement_id])
      end

      def spreadsheet_import_params
        params.require(:facilities_management_spreadsheet_import).permit(:spreadsheet_file, :facilities_management_procurement_id)
      end

      def redirect_to_requirements
        redirect_to facilities_management_procurement_path(@procurement) unless @procurement.detailed_search_bulk_upload?
      end

      protected

      def authorize_user
        @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
      end
    end
  end
end
