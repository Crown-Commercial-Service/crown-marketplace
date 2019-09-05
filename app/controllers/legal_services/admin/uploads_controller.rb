module LegalServices
  module Admin
    class UploadsController < FrameworkController
      before_action :authenticate_user!
      before_action :authorize_user

      def index
        @back_path = :back
        @uploads = Upload.all.page params[:page]
      end

      def show
        @back_path = :back
        @upload = Upload.find(params[:id])
        @attributes = Upload::ATTRIBUTES
      end

      def new
        @back_path = :back
        @upload = Upload.new
        @uploads_in_progress = Upload.in_review_or_in_progress
      end

      def create
        @upload = Upload.new(upload_params)
        @uploads_in_progress = Upload.in_review_or_in_progress

        if @upload.save
          LegalServices::DataUploadWorker.perform_async(@upload.id)
          redirect_to legal_services_admin_uploads_path
        else
          render :new
        end
      end

      def approve
        @upload = Upload.find(params[:upload_id])
        @upload.approve!

        redirect_to legal_services_admin_uploads_path
      end

      def reject
        @upload = Upload.find(params[:upload_id])
        @upload.reject!

        redirect_to legal_services_admin_uploads_path
      end

      def destroy
        upload = Upload.find(params[:upload_id])

        if upload.destroy
          redirect_to legal_services_admin_uploads_path
        else
          redirect_to :back
        end
      end

      private

      def upload_params
        params.require(:legal_services_admin_upload).permit(
          :suppliers,
          :rate_cards,
          :supplier_lot_1_service_offerings,
          :supplier_lot_2_service_offerings,
          :supplier_lot_3_service_offerings,
          :supplier_lot_4_service_offerings,
          :suppliers_data
        )
      end

      def authorize_user
        authorize! :manage, LegalServices::Admin::Upload
      end
    end
  end
end
