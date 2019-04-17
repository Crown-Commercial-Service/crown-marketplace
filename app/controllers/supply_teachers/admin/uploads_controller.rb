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
          redirect_to supply_teachers_admin_uploads_path, notice: 'Upload session successfully created.'
        else
          @upload.cleanup_input_files
          render :new
        end
      end

      def approve
        upload = Upload.find(params[:upload_id])
        suppliers = JSON.parse(File.read(data_file))

        SupplyTeachers::Upload.upload!(suppliers)

        upload.approve!

        redirect_to supply_teachers_admin_uploads_path, notice: 'Database has now been updated.'
      rescue ActiveRecord::RecordInvalid => e
        summary = {
          record: e.record,
          record_class: e.record.class.to_s,
          errors: e.record.errors
        }
        render show: summary, status: :unprocessable_entity
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

      def data_file
        if Rails.env.production?
          './lib/tasks/supply_teachers/output/data.json'
        else
          './lib/tasks/supply_teachers/output/anonymous.json'
        end
      end
    end
  end
end
