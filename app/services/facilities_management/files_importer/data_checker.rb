module FacilitiesManagement
  class FilesImporter::DataChecker
    def initialize(supplier_data)
      @supplier_data = supplier_data
      @errors = []
    end

    def check_data
      check_processed_data

      @errors
    end
  end
end
