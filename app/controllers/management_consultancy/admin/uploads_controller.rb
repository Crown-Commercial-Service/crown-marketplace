module ManagementConsultancy
  module Admin
    class UploadsController < FrameworkController
      skip_before_action :verify_authenticity_token, only: :create
      before_action :authenticate_user!
      before_action :authorize_user

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
      end

      def create
        @upload = ManagementConsultancy::Admin::Upload.new(upload_params)

        if @upload.save
          ManagementConsultancy::DataUploadWorker.perform_async(@upload.id)
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
        params.require(:management_consultancy_admin_upload).permit(:suppliers_data)
      end

      def authorize_user
        authorize! :manage, ManagementConsultancy::Admin::Upload
      end
    end
  end
end
