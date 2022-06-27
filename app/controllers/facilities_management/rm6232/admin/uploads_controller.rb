module FacilitiesManagement
  module RM6232
    module Admin
      class UploadsController < FacilitiesManagement::Admin::UploadsController
        private

        def upload_params
          params.require(:facilities_management_rm6232_admin_upload).permit(:supplier_details_file, :supplier_services_file, :supplier_regions_file) if params[:facilities_management_rm6232_admin_upload].present?
        end
      end
    end
  end
end
