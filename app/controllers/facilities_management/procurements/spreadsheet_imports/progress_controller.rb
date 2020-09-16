module FacilitiesManagement
  module Procurements
    module SpreadsheetImports
      class ProgressController < FacilitiesManagement::FrameworkController
        before_action :set_spreadsheet_import

        def index
          if user_authorised? && @spreadsheet_import
            continue_status = true
            refresh_status = @spreadsheet_import.succeeded? || @spreadsheet_import.failed?
          else
            refresh_status = false
            continue_status = false
          end

          render json: { refresh: refresh_status, continue: continue_status }
        end

        private

        def user_authorised?
          can? :manage, current_user.procurements.find_by(id: params[:procurement_id])
        end

        def set_spreadsheet_import
          @spreadsheet_import = SpreadsheetImport.find(params[:spreadsheet_import_id])
        rescue ActiveRecord::RecordNotFound
          @spreadsheet_import = nil
        end
      end
    end
  end
end
