module FacilitiesManagement::RM6232
  module Admin
    class FilesImporter::FilesProcessor < FacilitiesManagement::FilesImporter::FilesProcessor
      def process_files
        PROCESS_FILES_AND_METHODS.each do |file, check_method|
          read_spreadsheet(file) do |workbook|
            send(check_method, workbook)
          end
        end

        @supplier_data
      end

      private

      def add_supplier_details(suppliers_workbook)
        headers = {
          supplier_name: 'Supplier name',
          sme: 'SME',
          duns: 'DUNS number',
          registration_number: 'Registration number',
          address_line_1: 'Address line 1',
          address_line_2: 'Address line 2',
          address_town: 'Town',
          address_county: 'County',
          address_postcode: 'Postcode'
        }

        headers[:active] = 'Status' if suppliers_workbook.sheet(0).row(1).include? 'Status'

        @supplier_data = suppliers_workbook.sheet(0).parse(**headers).map { |supplier| supplier.transform_values(&:to_s) }

        @supplier_data.each do |supplier|
          supplier[:sme] = ['YES', 'Y'].include? supplier[:sme].to_s.upcase
          supplier[:active] = supplier[:active].to_s.upcase != 'INACTIVE'

          supplier[:id] = SecureRandom.uuid
        end
      end

      def add_supplier_services(services_workbook)
        get_data_from_lot_sheets(services_workbook) do |lot_sheet, lot_code|
          service_to_index = lot_sheet.column(2)[5..].map do |unformatted_service_code|
            next if unformatted_service_code.nil?

            "#{unformatted_service_code[1]}.#{unformatted_service_code[2..]}"
          end

          supplier_services_from_sheet(lot_sheet, lot_code, service_to_index).each do |supplier_services_data|
            supplier_data = @supplier_data.find { |data| data[:duns] == supplier_services_data[:duns] }

            if supplier_data
              supplier_data[:lot_data] ||= []
              supplier_data[:lot_data] << supplier_services_data[:lot_data]
            else
              add_missing_supplier(supplier_services_data)
            end
          end
        end
      end

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def add_supplier_regions(regions_workbook)
        get_data_from_lot_sheets(regions_workbook) do |regions_sheet, lot_code|
          supplier_regions_from_sheet(regions_sheet, lot_code).each do |supplier_regions_data|
            supplier_data = @supplier_data.find { |data| data[:duns] == supplier_regions_data[:duns] }

            if supplier_data
              if supplier_data[:lot_data] && (supplier_lot_data = supplier_data[:lot_data].find { |data| data[:lot_code] == supplier_regions_data[:lot_data][:lot_code] })
                supplier_lot_data[:region_codes] = supplier_regions_data[:lot_data][:region_codes]
              else
                supplier_data[:lot_data] ||= []
                supplier_data[:lot_data] << supplier_regions_data[:lot_data]
              end
            else
              add_missing_supplier(supplier_regions_data)
            end
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      # Shared methods for processing the files
      def get_data_from_lot_sheets(spreadsheet)
        %w[1 2 3].each do |lot_number|
          %w[a b c].each do |lot_letter|
            lot_code = "#{lot_number}#{lot_letter}"

            lot_sheet = spreadsheet.sheet("Lot #{lot_code}")

            yield(lot_sheet, lot_code)
          end
        end
      end

      # Methods relating to the extraction of service codes
      def supplier_services_from_sheet(lot_sheet, lot_code, service_to_index)
        (5..lot_sheet.last_column).map do |column_number|
          column = lot_sheet.column(column_number)

          supplier_duns = column[2].to_s

          supplier_service_codes = [] + core_serivce_codes[lot_code[0]]

          column[5..].each.with_index do |cell, index|
            supplier_service_codes << service_to_index[index] if cell&.downcase&.strip == 'yes'
          end

          { duns: supplier_duns, supplier_name: column[1].to_s, lot_data: { lot_code: lot_code, service_codes: supplier_service_codes } }
        end
      end

      def core_serivce_codes
        @core_serivce_codes ||= {
          '1' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(total: true, core: true).pluck(:code) }.flatten,
          '2' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(hard: true, core: true).pluck(:code) }.flatten,
          '3' => FacilitiesManagement::RM6232::WorkPackage.selectable.map { |work_package| work_package.supplier_services.where(soft: true, core: true).pluck(:code) }.flatten
        }
      end

      # Methods relating to the extraction of region codes
      def supplier_regions_from_sheet(regions_sheet, lot_code)
        (2..regions_sheet.last_row).map do |row_number|
          row = regions_sheet.row(row_number)
          supplier_duns = row[1].to_s

          supplier_region_codes = []

          row[2..].each.with_index do |cell, index|
            supplier_region_codes << region_codes[index] if cell&.downcase&.strip == 'x'
          end

          { duns: supplier_duns, supplier_name: row[0].to_s, lot_data: { lot_code: lot_code, region_codes: supplier_region_codes } }
        end
      end

      def region_codes
        @region_codes ||= FacilitiesManagement::Region.all.map(&:code)[0..-2] + ['NC01', 'OS01']
      end

      def add_missing_supplier(supplier_data)
        @supplier_data << { supplier_name: supplier_data[:supplier_name], duns: supplier_data[:duns], lot_data: [supplier_data[:lot_data]] }
      end

      PROCESS_FILES_AND_METHODS = {
        supplier_details_file: :add_supplier_details,
        supplier_services_file: :add_supplier_services,
        supplier_regions_file: :add_supplier_regions
      }.freeze
    end
  end
end
