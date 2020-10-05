module FacilitiesManagement
  module Procurements
    class SpreadsheetImportsController < FacilitiesManagement::FrameworkController
      include FacilitiesManagement::ControllerLayoutHelper
      before_action :set_procurement
      before_action :authorize_user
      before_action :set_spreadsheet_import, only: %i[show destroy]
      before_action :redirect_to_requirements

      def new
        @spreadsheet_import = FacilitiesManagement::SpreadsheetImport.new(facilities_management_procurement_id: params[:procurement_id])
      end

      def create
        @procurement.remove_existing_spreadsheet_import if @procurement.spreadsheet_import.present?
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
        initialize_errors if @spreadsheet_import.failed?
      end

      def destroy
        @spreadsheet_import.delete
        redirect_to new_facilities_management_procurement_spreadsheet_import_path(procurement_id: @procurement.id)
      end

      private

      def set_procurement
        @procurement = FacilitiesManagement::Procurement.find(params[:procurement_id])
      end

      def set_spreadsheet_import
        @spreadsheet_import = SpreadsheetImport.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to new_facilities_management_procurement_spreadsheet_import_path(procurement_id: @procurement.id)
      end

      def spreadsheet_import_params
        params.require(:facilities_management_spreadsheet_import).permit(:spreadsheet_file, :facilities_management_procurement_id)
      end

      def redirect_to_requirements
        redirect_to facilities_management_procurement_path(@procurement) unless @procurement.detailed_search_bulk_upload?
      end

      def initialize_errors
        @error_lists = if !@spreadsheet_import.import_errors.empty? && @spreadsheet_import.import_errors[:other_errors][:generic_error].present?
                         { other_errors: @spreadsheet_import.import_errors[:other_errors] }
                       else
                         {
                           building_errors: @spreadsheet_import.building_errors,
                           service_matrix_errors: @spreadsheet_import.service_matrix_errors,
                           service_volume_errors: @spreadsheet_import.service_volume_errors,
                           lift_errors: @spreadsheet_import.lift_errors,
                           service_hour_errors: @spreadsheet_import.service_hour_errors,
                           other_errors: @spreadsheet_import.import_errors.empty? ? [:other_errors] : []
                         }
                       end
      end

      protected

      def authorize_user
        @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
      end
    end
  end
end
