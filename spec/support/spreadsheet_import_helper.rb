module SpreadsheetImportHelper
  def bulk_upload_spreadsheet_builder(spreadsheet_path, buildings_details = [])
    package = Axlsx::Package.new
    package.workbook.add_worksheet(name: 'Instructions') do |sheet|
      9.times do
        sheet.add_row []
      end
      sheet.add_row ['Current status:', 'Ready to upload']
    end

    spreadsheet_buildings_builder(package, buildings_details)
    File.write(spreadsheet_path, package.to_stream.read)
  end

  private

  def spreadsheet_buildings_builder(package, buildings_details)
    buildings = buildings_details.map(&:first)
    package.workbook.add_worksheet(name: 'Building Information') do |sheet|
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
end
