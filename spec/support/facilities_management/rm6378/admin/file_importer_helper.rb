module FacilitiesManagement
  module RM6378
    class FileImporterHelper
      def initialize(**options)
        @package = Axlsx::Package.new
        @sheets = options[:sheets]
        @headers = options[:headers]
        @extra_supplier = options[:extra_supplier] || []
        @empty = options[:empty] || false
      end

      def write
        File.write(self.class::OUTPUT_PATH, @package.to_stream.read, binmode: true)
      end

      def self.sheets_with_extra_headers(sheets_with_extra_headers)
        self::SHEETS.map do |sheet|
          headers = self::HEADERS
          headers += ['Extra'] if sheets_with_extra_headers.include? sheet
          headers
        end
      end

      def suppliers(sheet_name)
        supplier_set = case sheet_name[-1]
                       when 'a'
                         SUPPLIERS_LOT_A
                       when 'b'
                         SUPPLIERS_LOT_B
                       when 'c'
                         SUPPLIERS_LOT_C
                       when 'd'
                         SUPPLIERS_LOT_D
                       end

        supplier_set = supplier_set.map { |supplier| [supplier[0], supplier[2]] }
        supplier_set += [@extra_supplier] if @extra_supplier.present?
        supplier_set
      end

      SUPPLIERS_LOT_A = [
        ['Rex LTD', 'Yes', '123456789',],
        ['Nia Corp', 'No', '234567891',],
        ['Tora LTD', 'Yes', '345678912',]
      ].freeze

      SUPPLIERS_LOT_B = [
        ['Tora LTD', 'Yes', '345678912',],
        ['Vandham Eexc Corp', 'No', '456789123',],
        ['Morag Jewel LTD', 'Yes', '567891234',]
      ].freeze

      SUPPLIERS_LOT_C = [
        ['Morag Jewel LTD', 'Yes', '567891234',],
        ['ZEKE VON GEMBU Corp', 'No', '678912345',],
        ['Jin Corp', 'Yes', '789123456',]
      ].freeze

      SUPPLIERS_LOT_D = [
        ['Jin Corp', 'Yes', '789123456',],
        ['Addam LTD', 'No', '891234567',],
        ['Hugo Corp', 'Yes', '912345678',]
      ].freeze

      SHEETS = ['Lot 1a', 'Lot 1b', 'Lot 1c', 'Lot 2a', 'Lot 2b', 'Lot 3a', 'Lot 3b', 'Lot 4a', 'Lot 4b', 'Lot 4c', 'Lot 4d'].freeze
    end

    class SupplierDetailsFile < FileImporterHelper
      def initialize(**options)
        options[:sheets] ||= SHEETS
        options[:headers] ||= [HEADERS] * options[:sheets].count

        super
      end

      def build
        @sheets.zip(@headers).each do |sheet_name, header_row|
          add_supplier_sheet(sheet_name, header_row)
        end
      end

      OUTPUT_PATH = './tmp/test_supplier_details_file.xlsx'.freeze

      SHEETS = ['RM6378 Suppliers Details'].freeze
      HEADERS = ['Supplier name', 'SME', 'DUNS number'].freeze

      private

      def add_supplier_sheet(sheet_name, header_row)
        supplier_details = (SUPPLIERS_LOT_A + SUPPLIERS_LOT_B + SUPPLIERS_LOT_C + SUPPLIERS_LOT_D).uniq
        supplier_details += [@extra_supplier] if @extra_supplier.present?

        @package.workbook.add_worksheet(name: sheet_name) do |sheet|
          sheet.add_row header_row
          next if @empty

          supplier_details.each do |supplier_detail|
            sheet.add_row supplier_detail[..-1]
          end
        end
      end
    end

    class SupplierServicesFile < FileImporterHelper
      def initialize(**options)
        options[:sheets] ||= SHEETS
        options[:headers] ||= self.class.generate_headers

        super
      end

      def self.sheets_with_extra_headers(sheets_with_extra_headers)
        self::SHEETS.zip(generate_headers).map do |sheet, sheet_headers|
          headers = sheet_headers
          headers += [['Extra', 'Extra']] if sheets_with_extra_headers.include? sheet
          headers
        end
      end

      def self.categories
        @categories ||= Framework.find('RM6378').lots.order(:number).map do |lot|
          services = Service.where(lot_id: lot.id)

          category_names = services.pluck(:category).uniq

          services.order(Arel.sql('SUBSTRING(number FROM 2)::integer'))
                  .group_by(&:category)
                  .sort_by { |category_name, _services| category_names.index(category_name) }
                  .map do |group, services|
                    [
                      group,
                      services.map do |service|
                        {
                          number: service.number,
                          name: service.name
                        }
                      end
                    ]
                  end
        end
      end

      def self.service_columns(index)
        categories[index].map do |category, services|
          [[category, category]] +
            services.map do |service|
              [service[:name], service[:number]]
            end +
            [[nil, nil]]
        end.flatten(1)[0..-2]
      end

      OUTPUT_PATH = './tmp/test_supplier_services_file.xlsx'.freeze

      def self.generate_headers
        self::SHEETS.map.with_index { |_, index| service_columns(index) }
      end

      def build
        @sheets.zip(@headers).each do |sheet_name, header_columns|
          add_services_sheet(sheet_name, header_columns)
        end
      end

      private

      def add_services_sheet(sheet_name, header_columns)
        supplier_names, supplier_duns, supplier_options = if @empty
                                                            [[], [], []]
                                                          else
                                                            suppliers = suppliers(sheet_name).transpose
                                                            suppliers + [['X', 'X'] + ([nil] * (suppliers.first.length - 2))]
                                                          end

        @package.workbook.add_worksheet(name: sheet_name) do |sheet|
          sheet.add_row ([nil] * 2) + supplier_names
          sheet.add_row ([nil] * 2) + supplier_duns
          sheet.add_row ['Service name', 'Service number']

          header_columns.each do |service_name_cell, service_code_cell|
            supplier_row = service_code_cell.nil? ? [] : supplier_options.rotate!

            sheet.add_row [service_name_cell, service_code_cell] + supplier_row
          end
        end
      end
    end

    class SupplierRegionsFile < FileImporterHelper
      def initialize(**options)
        options[:sheets] ||= SHEETS
        options[:headers] ||= [HEADERS] * options[:sheets].count

        super
      end

      def self.sheets_with_extra_headers(sheets_with_extra_headers)
        self::SHEETS.map do |sheet|
          headers = self::HEADERS
          headers += [['Extra', 'Extra']] if sheets_with_extra_headers.include? sheet
          headers
        end
      end

      HEADERS = Jurisdiction.regions_grouped_by_category.map do |category, regions|
        [
          [category, category]
        ] + regions.map do |region|
          [region.name, region.id]
        end + [
          [nil, nil]
        ]
      end.flatten(1)[0..-2].freeze

      OUTPUT_PATH = './tmp/test_supplier_regions_file.xlsx'.freeze

      def build
        @sheets.zip(@headers).each do |sheet_name, header_columns|
          add_regions_sheet(sheet_name, header_columns)
        end
      end

      private

      def add_regions_sheet(sheet_name, header_columns)
        supplier_names, supplier_duns, supplier_options = if @empty
                                                            [[], [], []]
                                                          else
                                                            suppliers = suppliers(sheet_name).transpose
                                                            suppliers + [['X', 'X'] + ([nil] * (suppliers.first.length - 2))]
                                                          end

        @package.workbook.add_worksheet(name: sheet_name) do |sheet|
          sheet.add_row ([nil] * 2) + supplier_names
          sheet.add_row ([nil] * 2) + supplier_duns
          sheet.add_row ['Region name', 'Region code']

          header_columns.each do |region_name_cell, region_code_cell|
            supplier_row = region_code_cell.nil? ? [] : supplier_options.rotate!

            sheet.add_row [region_name_cell, region_code_cell] + supplier_row
          end
        end
      end
    end
  end
end
