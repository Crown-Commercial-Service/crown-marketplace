module FacilitiesManagement
  module RM6378
    module Admin
      class UploadsController < FacilitiesManagement::Admin::FrameworkController
        include ::Admin::UploadActions

        private

        def upload_params
          params.expect(facilities_management_rm6378_admin_upload: %i[supplier_details_file supplier_services_file supplier_regions_file]) if params[:facilities_management_rm6378_admin_upload].present?
        end
      end
    end
  end
end
