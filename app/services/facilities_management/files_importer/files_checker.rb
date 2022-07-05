module FacilitiesManagement
  class FilesImporter::FilesChecker
    include FacilitiesManagement::FilesImporter::Helper

    def initialize(files_importer)
      @files_importer = files_importer
      @upload = files_importer.upload
      @errors = []
    end
  end
end
