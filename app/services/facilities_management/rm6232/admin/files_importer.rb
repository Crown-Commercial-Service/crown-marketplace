module FacilitiesManagement::RM6232
  module Admin
    class FilesImporter < FacilitiesManagement::FilesImporter
      def initialize(fm_upload = nil)
        super(fm_upload, FacilitiesManagement::RM6232::Admin)
      end

      private

      def other_data
        {}
      end

      def file_source
        if @upload
          @upload.supplier_data_file.filename.to_s
        else
          file_sources(:supplier_data_file)
        end
      end

      FILE_SOURCES = {
        supplier_details_file: Rails.root.join('data', 'facilities_management', 'rm6232', 'RM6232 Suppliers Details (for Dev & Test).xlsx'),
        supplier_services_file: Rails.root.join('data', 'facilities_management', 'rm6232', 'RM6232 Supplier Services (for Dev & Test).xlsx'),
        supplier_regions_file: Rails.root.join('data', 'facilities_management', 'rm6232', 'RM6232 Supplier Regions (for Dev & Test).xlsx')
      }.freeze
    end
  end
end
