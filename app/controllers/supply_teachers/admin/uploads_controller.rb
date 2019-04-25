module SupplyTeachers
  module Admin
    class UploadsController < FrameworkController

      def index
        @uploads = Upload.all
      end

      def new
        @upload = Upload.new
        @previous_uploaded_files = ::PreviousUploadedFilesPresenter.new
      end

      def create
        @upload = Upload.new(upload_params)
        @previous_uploaded_files = ::PreviousUploadedFilesPresenter.new

        if @upload.save
          SupplyTeachers::DataScriptWorker.perform_async(@upload.id)
          redirect_to supply_teachers_admin_uploads_path, notice: 'Upload session successfully created and is now in progress.'
        else
          @upload.cleanup_input_files
          render :new
        end
      end

      def approve
        upload = Upload.find(params[:upload_id])
        upload.upload!
        redirect_to supply_teachers_admin_uploads_path, notice: 'Database upload is now in progress.'
      end

      def reject
        upload = Upload.find(params[:upload_id])
        upload.reject!
        redirect_to supply_teachers_admin_uploads_path, notice: 'Upload session rejected.'
      end

      private

      def upload_params
        params.require(:supply_teachers_admin_upload).permit(:current_accredited_suppliers, :geographical_data_all_suppliers, :lot_1_and_lot_2_comparisons, :master_vendor_contacts, :neutral_vendor_contacts, :pricing_for_tool, :supplier_lookup)
      end

    end
  end
end
