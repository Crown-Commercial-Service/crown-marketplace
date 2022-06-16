module FacilitiesManagement
  module RM3830
    module Admin
      class UploadsController < FacilitiesManagement::Admin::FrameworkController
        before_action :set_upload, only: %i[show progress]

        def index
          @latest_upload = Upload.latest_upload
          @uploads = Upload.all.order(created_at: :desc).page params[:page]
        end

        def show; end

        def new
          @upload = Upload.new
        end

        def create
          @upload = Upload.new(upload_params)

          if @upload.save(context: :upload)
            @upload.start_upload!
            redirect_to facilities_management_rm3830_admin_upload_path(@upload)
          else
            render :new
          end
        end

        def spreadsheet_template
          spreadsheet_builder = SupplierFrameworkDataSpreadsheet.new
          spreadsheet_builder.build
          send_data spreadsheet_builder.to_xlsx, filename: 'RM30 Supplier Framework Data (template).xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        end

        def progress
          render json: { import_status: @upload.aasm_state }
        end

        private

        def set_upload
          @upload = Upload.find(params[:id] || params[:upload_id])
        end

        def upload_params
          params.require(:facilities_management_rm3830_admin_upload).permit(:supplier_data_file) if params[:facilities_management_rm3830_admin_upload].present?
        end
      end
    end
  end
end
