#!/usr/bin/env ruby

require 'roo'
require 'json'
require 'capybara'

branch_workbook = Roo::Spreadsheet.open './lib/tasks/supply_teachers/input/Geographical Data all suppliers.xlsx'

header_map = {
  'Supplier Name' => :supplier_name,
  'Branch Name/No.' => :branch_name,
  'Branch Contact name' => :contact_name,
  'Address 1' => :address_1,
  'Address 2' => :address_2,
  'Town' => :town,
  'County' => :county,
  'Post Code' => :postcode,
  'Branch Contact Name Email Address' => :email,
  'Branch Telephone Number' => :telephone,
  'Region' => :region,
}

def remap_headers(row, header_map)
  r = row.map do |k, v|
    [header_map[k], v]
  end
  r.to_h
end

def match_email_to_contacts(row)
  names = row[:contact_name].split(%r{[,/\n]+}m)
  emails = row[:email].split(/[;\s]+/)
  contacts = names.zip(emails)
  contacts = contacts.map { |(name, email)| { name: name, email: email } }
  new_row = if names.count != emails.count
              row.merge(contacts: [])
            else
              row.merge(contacts: contacts)
            end
  new_row.reject { |k, _v| %i[contact_name email].include? k }
end

def convert_html_fields_to_text(row)
  row.map { |k, v| [k, v.is_a?(String) ? Capybara.string(v).text : v] }.to_h
end

def convert_float_fields_to_int(row)
  row.map { |k, v| [k, v.is_a?(Float) ? v.to_i : v] }.to_h
end

def strip_fields(row)
  row.map { |k, v| [k, v.is_a?(String) ? v.strip : v] }.to_h
end

def strip_punctuation_from_postcode(row)
  row.merge(postcode: row[:postcode].gsub(/[^\w\s]/, ''))
end

def strip_keys_with_null_or_empty_values(row)
  row.reject { |_, v| v.nil? || v == '' }.to_h
end

def nest(row, key)
  supplier_name = row[:supplier_name]
  other_records = row.reject { |k, _v| k == :supplier_name }
  { :supplier_name => supplier_name, key => [other_records] }
end

# rubocop:disable Metrics/MethodLength
def collate(records)
  suppliers = records.map { |p| p[:supplier_name] }.uniq
  suppliers.map do |supplier|
    base_record = { supplier_name: supplier }
    supplier_records = records.select { |p| p[:supplier_name] == supplier }
    supplier_records.each do |rec|
      rec.each do |k, v|
        next if k == :supplier_name

        base_record[k] = [] unless base_record.key?(k)
        base_record[k] += v
      end
    end
    base_record
  end
end
# rubocop:enable Metrics/MethodLength

branch_sheet = branch_workbook.sheet('Branch details')

branches = branch_sheet.parse(header_search: ['Supplier Name'])
                       .map { |row| remap_headers(row, header_map) }
                       .map.with_index { |row, index| row.merge(line_no: index + 3) }
                       .map { |row| convert_html_fields_to_text(row) }
                       .map { |row| convert_float_fields_to_int(row) }
                       .map { |row| strip_fields(row) }
                       .map { |row| match_email_to_contacts(row) }
                       .map { |row| row }
                       .map { |row| strip_keys_with_null_or_empty_values(row) }
                       .map { |row| strip_punctuation_from_postcode(row) }

collated = collate(branches.map { |row| nest(row, :branches) })

puts JSON.pretty_generate(collated)
