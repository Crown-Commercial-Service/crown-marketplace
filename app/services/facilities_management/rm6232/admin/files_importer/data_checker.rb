module FacilitiesManagement::RM6232
  module Admin
    class FilesImporter::DataChecker < FacilitiesManagement::FilesImporter::DataChecker
      private

      def check_processed_data
        @errors = []

        check_missing_details_data
        check_missing_lot_data
        check_missing_lot_data_attribute(:service_codes, 'supplier_missing_services')
        check_missing_lot_data_attribute(:region_codes, 'supplier_missing_regions')

        @errors
      end

      def check_missing_details_data
        supplier_missing_details = @supplier_data.select { |supplier| supplier[:id].blank? }

        add_errors(supplier_missing_details, 'supplier_missing_details')
      end

      def check_missing_lot_data
        supplier_missing_lot_data = @supplier_data.select { |supplier| supplier[:lot_data].blank? }

        add_errors(supplier_missing_lot_data, 'supplier_missing_lot_data')
      end

      def check_missing_lot_data_attribute(attribute, error_name)
        supplier_missing_data = @supplier_data.select { |supplier| supplier[:lot_data]&.any? { |lot_data| lot_data[attribute].blank? } }

        add_errors(supplier_missing_data, error_name)
      end

      def add_errors(missing_data, error_name)
        @errors << { error: error_name, details: missing_data.pluck(:supplier_name) } if missing_data.any?
      end
    end
  end
end
