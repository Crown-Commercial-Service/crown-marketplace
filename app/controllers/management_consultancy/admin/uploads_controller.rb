module ManagementConsultancy
  module Admin
    class UploadsController < FrameworkController
      def index
        @back_path = :back
        @uploads = ManagementConsultancy::Admin::Upload.all.page params[:page]
      end

      def show
        @back_path = :back
        @upload = ManagementConsultancy::Admin::Upload.find(params[:id])
      end

      def new
        @back_path = :back
        @upload = ManagementConsultancy::Admin::Upload.new
        @uploads_in_progress = ManagementConsultancy::Admin::Upload.in_review_or_in_progress?
      end

      def create
        @upload = ManagementConsultancy::Admin::Upload.new(upload_params)

        if @upload.save
          ManagementConsultancy::DataScriptWorker.perform_async(@upload.id)
          redirect_to management_consultancy_admin_in_progress_path
        else
          @upload.cleanup_input_files
          render :new
        end
      end

      def approve
        upload = ManagementConsultancy::Admin::Upload.find(params[:upload_id])
        upload.upload!
        redirect_to management_consultancy_admin_upload_uploading_path(upload_id: upload.id)
      end

      def reject
        upload = ManagementConsultancy::Admin::Upload.find(params[:upload_id])
        upload.reject!
        redirect_to management_consultancy_admin_uploads_path, notice: 'Upload session rejected.'
      end

      def in_progress; end

      def uploading
        @upload = ManagementConsultancy::Admin::Upload.find(params[:upload_id])
      end

      private

      def upload_params
        params.require(:management_consultancy_admin_upload).permit(:suppliers, :supplier_regional_offerings, :supplier_service_offerings, :rate_cards)
      end
    end
  end
end
