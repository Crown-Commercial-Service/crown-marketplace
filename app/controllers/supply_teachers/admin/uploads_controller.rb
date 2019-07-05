module SupplyTeachers
  module Admin
    class UploadsController < FrameworkController
      before_action :authenticate_user!
      before_action :authorize_user

      def index
        @back_path = :back
        @uploads = Upload.all.page params[:page]
        setup_previous_uploaded_files
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
          SupplyTeachers::DataScriptWorker.perform_async(@upload.id)
          redirect_to supply_teachers_admin_in_progress_path
        else
          @upload.cleanup_input_files
          render :new
        end
      end

      def approve
        upload = Upload.perform_upload(params[:upload_id])
        redirect_to supply_teachers_admin_upload_uploading_path(upload_id: upload.id)
      end

      def reject
        @upload = Upload.find(params[:upload_id])
        @upload.reject!
      end

      def in_progress; end

      def uploading
        @upload = Upload.find(params[:upload_id])
      end

      def destroy
        upload = Upload.find(params[:upload_id])

        if upload.destroy
          redirect_to supply_teachers_admin_uploads_path
        else
          redirect_to :back
        end
      end

      private

      def upload_params
        params.require(:supply_teachers_admin_upload).permit(:current_accredited_suppliers, :geographical_data_all_suppliers, :lot_1_and_lot_2_comparisons, :master_vendor_contacts, :neutral_vendor_contacts, :pricing_for_tool, :supplier_lookup, :current_accredited_suppliers_cache, :geographical_data_all_suppliers_cache, :lot_1_and_lot_2_comparisons_cache, :master_vendor_contacts_cache, :neutral_vendor_contacts_cache, :pricing_for_tool_cache, :supplier_lookup_cache)
      end

      def setup_previous_uploaded_files
        @current_uploads = []
        Upload::ATTRIBUTES.each do |attr|
          object = Upload.previous_uploaded_file_object(attr)
          next if object.nil?

          @current_uploads << {
            file_path: object.send(attr).url,
            upload_id: object.id,
            attribute_name: attr,
            short_uuid: object.short_uuid
          }
        end
      end

      def authorize_user
        authorize! :manage, SupplyTeachers::Admin::Upload
      end
    end
  end
end
