module FacilitiesManagement::RM3830
  module Admin
    class SupplierFrameworkDataImporter
      IMPORT_PROCESS_ORDER = %i[check_file process_file check_processed_data publish_data].freeze

      def initialize(supplier_data_upload = nil)
        @supplier_data_upload = supplier_data_upload
        @errors = []
      end

      def import_data
        IMPORT_PROCESS_ORDER.each do |import_process|
          @supplier_data_upload.send("#{import_process}!")
          send(import_process)
          break if @errors.any?
        end

        if @errors.any?
          @supplier_data_upload.update(import_errors: @errors)
          @supplier_data_upload.fail!
        else
          @supplier_data_upload.publish!
        end
      rescue StandardError => e
        @supplier_data_upload.update(import_errors: [error: 'upload_failed'])
        @supplier_data_upload.fail!

        Rollbar.log('error', e)
      end

      def import_test_data
        @test_supplier_data_spreadsheet = Rails.root.join('data', 'facilities_management', 'rm3830', 'RM3830 Direct Award Data (for Dev & Test).xlsx')

        process_file
        publish_data
      end

      private

      ########## Checking that the files match the template ##########
      def check_file
        read_spreadsheet do |supplier_data_workbook|
          if supplier_data_workbook.sheets != ['Prices', 'Variances']
            @errors << { error: 'supplier_data_missing_sheets' }
          else
            @errors << { error: 'pricing_sheet_headers_incorrect' } if supplier_data_workbook.sheet(0).row(1) != ['Supplier', 'Service Ref', 'Service Name', 'Unit of Measure', 'General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary Schools', 'Special Schools', 'Universities and Colleges', 'Community - Doctors, Dentist, Health Clinic', 'Nursing and Care Homes', 'Direct Award Discount %']
            @errors << { error: 'variances_sheet_headers_incorrect' } if supplier_data_workbook.sheet(1).column(1) != ['Supplier', 'Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)']
          end
        end
      rescue StandardError => e
        Rollbar.log('error', e)
        @errors << { error: 'file_check_failed' }
      end

      ########## Extracting the data from the files into a hash ##########
      def process_file
        @supplier_data = { 'Prices' => lot_1a_suppliers, 'Discounts' => lot_1a_suppliers, 'Variances' => lot_1a_suppliers }

        read_spreadsheet do |supplier_data_workbook|
          add_prices(supplier_data_workbook.sheet('Prices'))
          add_variances(supplier_data_workbook.sheet('Variances'))
        end
      rescue StandardError => e
        Rollbar.log('error', e)
        @errors << { error: 'file_process_failed' }
      end

      def lot_1a_suppliers
        SupplierDetail.suppliers_offering_lot('1a').index_with { {} }
      end

      def add_prices(sheet)
        labels = sheet.row(1)[0..-2]
        last_row = sheet.last_row

        (2..last_row).each do |row_number|
          row = sheet.row(row_number)
          rate_card = labels.zip(row).to_h

          next unless rate_card['Service Ref']

          @supplier_data['Prices'][rate_card['Supplier']] ||= {}

          @supplier_data['Prices'][rate_card['Supplier']][rate_card['Service Ref']] = rate_card
          add_discounts(row.last, rate_card)
        end
      end

      def add_discounts(discount, rate_card)
        @supplier_data['Discounts'][rate_card['Supplier']] ||= {}

        @supplier_data['Discounts'][rate_card['Supplier']][rate_card['Service Ref']] = { 'Disc %' => discount.try(:abs) || discount }.merge(rate_card.slice('Supplier', 'Service Ref', 'Service Name'))
      end

      def add_variances(sheet)
        labels = sheet.column(1)
        last_column = sheet.last_column

        (2..last_column).each do |column_number|
          column = sheet.column(column_number)

          rate_card = labels.zip(column).to_h

          @supplier_data['Variances'][rate_card['Supplier']] ||= {}

          @supplier_data['Variances'][rate_card['Supplier']] = rate_card
        end
      end

      ########## Checking that data that has been imported is valid ##########
      def check_processed_data
        supplier_errors = {}
        supplier_errors['prices'] = validate_data('Prices', ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary Schools', 'Special Schools', 'Universities and Colleges', 'Community - Doctors, Dentist, Health Clinic', 'Nursing and Care Homes'])
        supplier_errors['discounts'] = validate_data('Discounts', ['Disc %'])
        supplier_errors['variances'] = validate_variance_data

        return if supplier_errors.all? { |_, errors| errors.empty? }

        supplier_errors.each do |rate_type, errors|
          errors.each do |error_type, error_details|
            @errors << { error: "#{rate_type}_#{error_type}", details: error_details }
          end
        end
      end

      def validate_data(key, rate_types)
        validate_each(key) do |supplier, supplier_rates, supplier_errors|
          supplier_rates.each do |code, rate|
            rate_types.each do |type|
              required_validation = validation_type(key, code)
              validation = RateValidator.new(rate[type].to_s, required_validation == :full_range)

              next if validation.valid?(required_validation)

              supplier_errors[validation.error_type] ||= []
              supplier_errors[validation.error_type] << supplier
            end
          end
        end
      end

      def validate_variance_data
        validate_each('Variances') do |supplier, supplier_variances, supplier_errors|
          next if supplier_variances.empty?

          ['Management Overhead %', 'Corporate Overhead %', 'Profit %', 'London Location Variance Rate (%)', 'Cleaning Consumables per Building User (£)', 'TUPE Risk Premium (DA %)', 'Mobilisation Cost (DA %)'].each do |type|
            required_validation = validation_type('Variances', type)
            variance_validation = RateValidator.new(supplier_variances[type].to_s, required_validation == :full_range)

            next if variance_validation.valid?(required_validation)

            supplier_errors[variance_validation.error_type] ||= []
            supplier_errors[variance_validation.error_type] << supplier
          end
        end
      end

      def validate_each(key)
        supplier_errors = {}

        @supplier_data[key].each do |supplier, supplier_rates|
          yield(supplier, supplier_rates, supplier_errors)
        end

        supplier_errors.each { |_, suppliers| suppliers.uniq! }
      end

      def validation_type(key, code)
        case key
        when 'Prices'
          :full_range if ['M.1', 'N.1'].include?(code)
        when 'Discounts'
          :full_range
        when 'Variances'
          :full_range unless code == 'Cleaning Consumables per Building User (£)'
        end
      end

      ########## Save the data into the database ##########
      def publish_data
        rate_card = RateCard.create(data: converted_data, source_file: file_source)

        Rails.logger.info "FM rate cards spreadsheet #{file_source} (#{rate_card.data.count} sheets) imported into database"
      rescue StandardError => e
        Rollbar.log('error', e)
        @errors << { error: 'file_publish_failed' }
      end

      def converted_data
        FacilitiesManagement::RakeModules::ConvertSupplierNames.new(:current_supplier_name_to_id).map_supplier_keys(@supplier_data)
      end

      def file_source
        @test_supplier_data_spreadsheet || @supplier_data_upload.supplier_data_file.filename.to_s
      end

      ########## Methods to help read the spreadsheet ##########
      def read_spreadsheet
        workbook = Roo::Spreadsheet.open(@test_supplier_data_spreadsheet || supplier_data_spreadsheet, extension: :xlsx)

        yield(workbook)
      ensure
        workbook.close
      end

      def supplier_data_spreadsheet
        tmpfile = Tempfile.create
        tmpfile.binmode
        tmpfile.write @supplier_data_upload.supplier_data_file.download
        tmpfile.close

        tmpfile.path
      end
    end
  end
end
