module FacilitiesManagement
  class FilesImporter::FilesProcessor
    include FacilitiesManagement::FilesImporter::Helper

    def initialize(files_importer)
      @files_importer = files_importer
      @upload = files_importer.upload
      @supplier_data = []
    end
  end
end
