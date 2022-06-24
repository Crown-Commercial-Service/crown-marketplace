module FacilitiesManagement::RM3830
  module Admin
    class FilesImporter::DataUploader < FacilitiesManagement::FilesImporter::DataUploader
      def self.upload!(supplier_data, file_source:)
        super(RateCard) do
          rate_card = RateCard.create(data: converted_data(supplier_data), source_file: file_source)

          Rails.logger.info "FM rate cards spreadsheet #{file_source} (#{rate_card.data.count} sheets) imported into database"
        end
      end

      def self.converted_data(supplier_data)
        FacilitiesManagement::RakeModules::ConvertSupplierNames.new(:current_supplier_name_to_id).map_supplier_keys(supplier_data)
      end
    end
  end
end
