module SupplyTeachers
  module Admin
    class UploadsController < FrameworkController
      def index
        @back_path = :back
        @uploads = Upload.all
      end

      def show
        @back_path = :back
        @upload = Upload.find(params[:id])
      end

      def new
        @back_path = :back
        @upload = Upload.new
        @uploads_in_progress = Upload.in_review_or_in_progress?
      end

      def create
        @upload = Upload.new(upload_params)

        if @upload.save
          SupplyTeachers::DataScriptWorker.perform_async(@upload.id)
          redirect_to supply_teachers_admin_in_progress_path
        else
          @upload.cleanup_input_files
          render :new
        end
      end

      def approve
        upload = Upload.find(params[:upload_id])
        upload.upload!
        redirect_to supply_teachers_admin_upload_uploading_path(upload_id: upload.id)
      end

      def reject
        upload = Upload.find(params[:upload_id])
        upload.reject!
        redirect_to supply_teachers_admin_uploads_path, notice: 'Upload session rejected.'
      end

      def in_progress; end

      def uploading
        @upload = Upload.find(params[:upload_id])
      end

      private

      def upload_params
        params.require(:supply_teachers_admin_upload).permit(:current_accredited_suppliers, :geographical_data_all_suppliers, :lot_1_and_lot_2_comparisons, :master_vendor_contacts, :neutral_vendor_contacts, :pricing_for_tool, :supplier_lookup, :current_accredited_suppliers_cache, :geographical_data_all_suppliers_cache, :lot_1_and_lot_2_comparisons_cache, :master_vendor_contacts_cache, :neutral_vendor_contacts_cache, :pricing_for_tool_cache, :supplier_lookup_cache)
      end
    end
  end
end
