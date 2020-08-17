module SpreadsheetImportHelper
  # Creates fake bulk upload spreadsheet.
  # Caveats:
  #   1. Only adds the sheets you ask for
  #   2. The sheets may not be in the same order as the real spreadsheet
  class FakeBulkUploadSpreadsheet
    def initialize
      @package = Axlsx::Package.new
      @sheets_added = []
    end

    OUTPUT_PATH = './tmp/test.xlsx'.freeze

    def write
      File.write(OUTPUT_PATH, @package.to_stream.read)
    end

    def add_building_sheet(buildings_details)
      name = 'Building Information'
      @sheets_added << name
      buildings = buildings_details.map(&:first)
      @package.workbook.add_worksheet(name: name) do |sheet|
        sheet.add_row(['Building Number'] + buildings.map.with_index { |_, i| "Building #{i + 1}" })
        sheet.add_row(['Building Name'] + buildings.map(&:building_name))
        sheet.add_row(['Building Description'] + buildings.map(&:description))
        sheet.add_row(['Building Address - Street'] + buildings.map(&:address_line_1))
        sheet.add_row(['Building Address - Town'] + buildings.map(&:address_town))
        sheet.add_row(['Building Address - Postcode'] + buildings.map(&:address_postcode))
        sheet.add_row(['Building Gross Internal Area (GIA) (sqm)'] + buildings.map(&:gia))
        sheet.add_row(['Building External Area (sqm)'] + buildings.map(&:external_area))
        sheet.add_row(['Building Type'] + buildings.map(&:building_type))
        sheet.add_row(['Building Type (other)'] + buildings.map(&:other_building_type))
        sheet.add_row(['Building Security Clearance'] + buildings.map(&:security_type))
        sheet.add_row(['Building Security Clearance (other)'] + buildings.map(&:other_security_type))
        sheet.add_row(['Status indicator:'] + buildings_details.map(&:last))
      end
    end

    def add_service_matrix_sheet(data)
      name = 'Service Matrix'
      @sheets_added << name
      template_sheet = template_spreadsheet.sheet(name)
      template_sheet_row_count = template_sheet.parse.size + 1

      @package.workbook.add_worksheet(name: name) do |sheet|
        status_indicators = data.map { |building| building[:status] }
        sheet.add_row(template_sheet.row(1) + status_indicators)

        building_names = data.map { |building| building[:building_name] }
        sheet.add_row(template_sheet.row(2) + building_names)

        sheet.add_row(template_sheet.row(3))

        (4..template_sheet_row_count).each do |row_num|
          row_vals = template_sheet.row(row_num)
          service_ref = row_vals[0]
          service_selections = data.map { |building| building[:services].include?(service_ref) ? 'Yes' : nil }
          sheet.add_row(row_vals + service_selections)
        end
      end
    end

    def template_spreadsheet
      Roo::Spreadsheet.open(FacilitiesManagement::SpreadsheetImporter::TEMPLATE_FILE_PATH, extension: :xlsx)
    end

    def add_missing_sheets_from_template
      template_spreadsheet.sheets.each do |template_sheet_name|
        next if @sheets_added.include?(template_sheet_name)

        # Add sheet from template
        @package.workbook.add_worksheet(name: template_sheet_name) do |fake_sheet|
          # We have to use `each_row_streaming` for the `pad_cells` option, else blank cells are ignored
          template_spreadsheet.sheet(template_sheet_name).each_row_streaming(pad_cells: true) do |cell_objects|
            row_values = cell_objects.map { |cell_object| cell_object.nil? ? '' : cell_object.value } # Convert to simple array of values
            fake_sheet.add_row(row_values)
          end
        end
      end
    end
  end
end
