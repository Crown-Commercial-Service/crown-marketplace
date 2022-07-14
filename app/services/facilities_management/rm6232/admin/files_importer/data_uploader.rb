module FacilitiesManagement::RM6232
  module Admin
    class FilesImporter::DataUploader < FacilitiesManagement::FilesImporter::DataUploader
      def self.upload!(supplier_data, upload:)
        super(Supplier) do
          Supplier.destroy_all

          supplier_data.each { |supplier| create_supplier!(supplier) }

          SupplierData.create!(upload: upload, data: supplier_data)
        end
      end

      def self.create_supplier!(supplier_data)
        supplier = Supplier.create!(**supplier_data.except(:lot_data))

        supplier_data[:lot_data].each do |lot_data|
          supplier.lot_data.create!(**lot_data)
        end
      end
    end
  end
end
