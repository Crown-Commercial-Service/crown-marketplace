module FacilitiesManagement
  module RM3830
    module Procurements
      class SpreadsheetImportsController < FacilitiesManagement::FrameworkController
        before_action :set_procurement
        before_action :authorize_user
        before_action :set_spreadsheet_import, only: %i[show destroy progress]
        before_action :redirect_to_requirements

        def show
          initialize_errors if @spreadsheet_import.failed?
        end

        def new
          @spreadsheet_import = SpreadsheetImport.new(facilities_management_rm3830_procurement_id: params[:procurement_id])
        end

        def create
          @procurement.remove_existing_spreadsheet_import if @procurement.spreadsheet_import.present?

          (cancel_and_return && return) if params[:cancel_and_return].present?

          @spreadsheet_import = SpreadsheetImport.new(spreadsheet_import_params)
          if @spreadsheet_import.save(context: :upload)
            @spreadsheet_import.start_import!
            redirect_to facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: @spreadsheet_import.procurement.id, id: @spreadsheet_import.id)
          else
            @spreadsheet_import.destroy
            render :new
          end
        end

        def destroy
          @spreadsheet_import.delete
          redirect_to new_facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: @procurement.id)
        end

        def progress
          render json: { import_status: @spreadsheet_import.data_import_state }
        end

        private

        def set_procurement
          @procurement = Procurement.find(params[:procurement_id])
        end

        def set_spreadsheet_import
          @spreadsheet_import = SpreadsheetImport.find(params[:id] || params[:spreadsheet_import_id])
        rescue ActiveRecord::RecordNotFound
          redirect_to new_facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: @procurement.id)
        end

        def spreadsheet_import_params
          params.require(:facilities_management_rm3830_spreadsheet_import).permit(:spreadsheet_file, :facilities_management_rm3830_procurement_id)
        end

        def redirect_to_requirements
          redirect_to facilities_management_rm3830_procurement_path(@procurement) unless @procurement.detailed_search_bulk_upload?
        end

        def initialize_errors
          @error_lists = if import_error_type == :normal
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

        def import_error_type
          @import_error_type ||= if @spreadsheet_import.import_errors.any? && @spreadsheet_import.import_errors[:other_errors]
                                   if @spreadsheet_import.import_errors[:other_errors][:file_check_error].present?
                                     :template
                                   else
                                     :generic
                                   end
                                 else
                                   :normal
                                 end
        end

        def cancel_and_return
          @procurement.spreadsheet_import.destroy if @procurement.spreadsheet_import.present?

          redirect_to facilities_management_rm3830_procurement_path(id: @procurement.id, spreadsheet: true)
        end

        protected

        def authorize_user
          @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
        end
      end
    end
  end
end
