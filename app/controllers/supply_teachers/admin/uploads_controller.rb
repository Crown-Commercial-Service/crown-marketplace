module SupplyTeachers
  module Admin
    class UploadsController < FrameworkController

      def index
        @uploads = Upload.all
      end

      def new
        @upload = Upload.new
      end

      def create
        @upload = Upload.new(upload_params)
        @upload.state = 'created'

        if @upload.save
          redirect_to supply_teachers_admin_uploads_path
        else
          render :new
        end
      end

      private

      def upload_params
        params.require(:supply_teachers_admin_upload).permit(:current_accredited_suppliers, :geographical_data_all_suppliers, :lot_1_and_lot_2_comparisons, :master_vendor_contacts, :neutral_vendor_contacts, :pricing_for_tool, :supplier_lookup)
      end
    end
  end
end
