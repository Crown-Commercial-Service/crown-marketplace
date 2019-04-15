#!/usr/bin/env ruby
# rubocop:disable Metrics/LineLength
require 'roo'
require 'json'
require 'securerandom'
require 'uk_postcode'
require 'geocoder'
require 'capybara'
require 'pathname'
require 'yaml'

accredited_suppliers_workbook = Roo::Spreadsheet.open './lib/tasks/supply_teachers/input/Current_Accredited_Suppliers_.xlsx'

header_map = {
  'Supplier Name - Accreditation Held' => :supplier_name,
  'Supplier Name' => :supplier_name
}

def remap_headers(row, header_map)
  r = row.map do |k, v|
    [header_map[k], v]
  end
  r.to_h
end

def strip_fields(row)
  row.map { |k, v| [k, v.is_a?(String) ? v.strip : v] }.to_h
end

def add_accreditation(row)
  row.merge(accreditation: true)
end

lot_1_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 1 - Preferred Supplier List')
lot_1_accreditation =
  lot_1_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])
                           .map            { |row| remap_headers(row, header_map) }
                           .map.with_index { |row, index| row.merge(line_no: index + 1) }
                           .reject         { |row| row[:supplier_name].nil? || row[:supplier_name] == '' }
                           .map            { |row| strip_fields(row) }
                           .map            { |row| add_accreditation(row) }

lot_2_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 2 - Master Vendor MSP')
lot_2_accreditation =
  lot_2_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])
                           .map            { |row| remap_headers(row, header_map) }
                           .map.with_index { |row, index| row.merge(line_no: index + 1) }
                           .reject         { |row| row[:supplier_name].nil? || row[:supplier_name] == '' }
                           .map            { |row| strip_fields(row) }
                           .map            { |row| add_accreditation(row) }

lot_3_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 3 - Neutral Vendor MSP')
lot_3_accreditation =
  lot_3_accreditation_sheet.parse(header_search: ['Supplier Name'])
                           .map            { |row| remap_headers(row, header_map) }
                           .map.with_index { |row, index| row.merge(line_no: index + 1) }
                           .reject         { |row| row[:supplier_name].nil? || row[:supplier_name] == '' }
                           .map            { |row| strip_fields(row) }
                           .map            { |row| add_accreditation(row) }

accreditation = lot_1_accreditation + lot_2_accreditation + lot_3_accreditation
# rubocop:disable Rails/Output
puts JSON.pretty_generate(accreditation)
# rubocop:enable Rails/Output
