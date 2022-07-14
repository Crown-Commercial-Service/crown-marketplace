module FacilitiesManagement
  module Admin
    class UploadsController < FacilitiesManagement::Admin::FrameworkController
      before_action :set_upload, only: %i[show progress]

      def index
        @latest_upload = service::Upload.latest_upload
        @uploads = service::Upload.all.page params[:page]
      end

      def show; end

      def new
        @upload = service::Upload.new
      end

      def create
        @upload = service::Upload.new(user: current_user)

        @upload.assign_attributes(upload_params)

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
        @upload = service::Upload.find(params[:id] || params[:upload_id])
      end

      def authorize_user
        authorize! :manage, service::Upload
      end

      def service
        @service ||= self.class.module_parent
      end

      def upload_params
        if params[param_key]
          params.require(param_key).permit(@upload.class::ATTRIBUTES)
        else
          {}
        end
      end

      def param_key
        @param_key ||= @upload.model_name.param_key
      end
    end
  end
end
