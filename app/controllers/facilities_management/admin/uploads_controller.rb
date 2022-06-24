module FacilitiesManagement
  module Admin
    class UploadsController < FacilitiesManagement::Admin::FrameworkController
      before_action :set_upload, only: %i[show progress]

      def index
        @latest_upload = service::Admin::Upload.latest_upload
        @uploads = service::Admin::Upload.all.page params[:page]
      end

      def show; end

      def new
        @upload = service::Admin::Upload.new
      end

      def create
        @upload = service::Admin::Upload.new(upload_params)

        if @upload.save(context: :upload)
          @upload.start_upload!
          redirect_to @upload
        else
          render :new
        end
      end

      def progress
        render json: { import_status: @upload.aasm_state }
      end

      private

      def set_upload
        @upload = service::Admin::Upload.find(params[:id] || params[:upload_id])
      end

      def authorize_user
        authorize! :manage, service::Admin::Upload
      end

      def service
        @service ||= self.class.module_parent.module_parent
      end
    end
  end
end
