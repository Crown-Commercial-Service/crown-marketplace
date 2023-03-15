module FacilitiesManagement::RM3830
  module Admin
    class FilesImporter < FacilitiesManagement::FilesImporter
      def initialize(fm_upload = nil)
        super(fm_upload, FacilitiesManagement::RM3830::Admin)
      end

      private

      def other_data
        { file_source: }
      end

      def file_source
        if @upload
          @upload.supplier_data_file.filename.to_s
        else
          file_sources(:supplier_data_file)
        end
      end

      FILE_SOURCES = {
        supplier_data_file: Rails.root.join('data', 'facilities_management', 'rm3830', 'RM3830 Direct Award Data (for Dev & Test).xlsx')
      }.freeze
    end
  end
end
