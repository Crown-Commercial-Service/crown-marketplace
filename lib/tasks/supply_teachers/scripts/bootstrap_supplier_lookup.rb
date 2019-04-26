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

branch_workbook = Roo::Spreadsheet.open './lib/tasks/supply_teachers/input/Geographical Data all suppliers.xlsx'
price_workbook = Roo::Spreadsheet.open './lib/tasks/supply_teachers/input/pricing for tool.xlsx'
mv_price_workbook = Roo::Spreadsheet.open './lib/tasks/supply_teachers/input/Lot_1_and_2_comparisons.xlsx'
accredited_suppliers_workbook = Roo::Spreadsheet.open './lib/tasks/supply_teachers/input/Current_Accredited_Suppliers_.xlsx'

extra_supplier_names = [
  # only has offerings in Lot 2 (master vendor)
  # and doesn't appear in branch_workbook
  'Guidant Group',
  # only has offerings in Lot 3 (neutral vendor)
  'GRI UK'
]

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
  'Bidder Name' => :supplier_name,
  'Supplier Name - Accreditation Held' => :supplier_name
}

name_map = {
  '4myschools Education' => '4myschools',
  'A-Day Consultants Ltd t/a Academics, Servoca Education and Classic Education' => 'Academics, Servoca Education and Classic Education',
  'A-Day Consultants t/a Academics, Servoca Education, Classic Education, and Academics Advance' => 'Academics, Servoca Education and Classic Education',
  'Academic Solutions UK Ltd' => 'Academic Solutions',
  'Affinity Workforce Limited t/a Monarch Education Limited' => 'Monarch Education Limited',
  'Apollo Teaching' => 'Apollo Teaching Services',
  'Apollo Teaching t/a Apollo Teaching Services Ltd' => 'Apollo Teaching Services',
  'Asphalia Holdings Limited' => 'Ashpalia Holdings t/a Care Field',
  'Aurelia Education Ltd' => 'Aurelia Education Ltd.',
  'Balfor Recruitment t/a Boston Clark' => 'Balfor Recruitment a trading name of Boston ClarK Ltd',
  'Bumblebee Education Ltd.' => 'BumbleBee Education LTD',
  'Castles Education' => 'Castles Education LLP',
  'Celsian Group Limited' => 'Celsian Education',
  'City of York Trading Limited (Trading as WorkwithSchools)' => 'City of York Trading Limited Trading as WorkwithSchools',
  'Coyle Personnel plc t/a Coyle Education' => 'Coyle Personnel plc',
  'Day Webster Education Ltd' => 'Day Wester Ltd',
  'Education Recruitment Ltd T/A Travail Education' => 'Education Recruitment Ltd',
  'Education Recruitment Ltd t/a Travail Education' => 'Education Recruitment Ltd',
  'EYPS Ltd t/a EYPS Teaching Supply' => 'EYPS Ltd',
  'Exclusive Education Ltd' => 'Exclusvie Education',
  'First for Education' => 'First For Education Ltd.',
  'GRI UK (formerly de Poel)' => 'GRI UK',
  'Guardian Selection Limited (trading as GSL Education)' => 'Guardian Selection Limited, trading as GSL Education',
  'GSL Education t/a Guardian Selection Limited' => 'Guardian Selection Limited, trading as GSL Education',
  'Hoople Ltd' => 'Hoople Recruitment',
  'Just Teachers' => 'justteachers',
  'LB Education Services Limited (t/a Class People)' => 'Class People',
  'LB Education Services Ltd t/a Class People' => 'Class People',
  'Mana Resourcing Ltd (t/a Mana Education)' => 'Mana Education',
  'Master Class Education Ltd' => 'MasterClass Education LTD',
  'Media & Data Services Ltd T/A Inspiring Teaching' => 'Inspiring Teaching',
  'Monarch Education (Affinity Workforce)' => 'Monarch Education Limited',
  'New Directions Ltd' => 'New Directions Education Ltd',
  'OR Education Ltd t/a Axcis Education Recruitment' => 'Axcis Education',
  'Prospero Teaching' => 'Prospero Group Ltd',
  'Protocol t/a Teaching Force' => 'Protocol',
  'Randstad' => 'Randstad public services',
  'Randstad Education' => 'Randstad public services',
  'REd Ltd t/a REd Teachers and REd (Recruitment for Education)' => 'REd Ltd',
  'Reed Specialist Recruitment Ltd.' => 'Reed Education',
  'Reed Specialist Recruitment Ltd' => 'Reed Education',
  'Reed Recruitment' => 'Reed Education',
  'Remedy Recruitment Group t/a Remedy Education' => 'Remedy Recruitment Group',
  'School Improvement Liverpool Recruitment' => 'School Improvement Liverpool Limited',
  'Shares' => 'SHARES Lancashire',
  'Simply Supply Ltd.' => 'Simply Supply Limited',
  'Smile' => 'Smile Education',
  'TLTP' => 'London Teaching Pool Limited',
  'Teaching Services (SW) Ltd (t/a Cover Teachers)' => 'Cover Teachers',
  'Tempest' => 'Tempest Resoucing Limited',
  'Textbook Teachers Education and Recruitment Services Ltd' => 'Textbook Teachers Ltd',
  'TEXTBOOK TEACHERS EDUCATION AND RECRUITMENT SERVICES LTD t/a Textbook Teachers Ltd' => 'Textbook Teachers Ltd',
  'The FRCE Recruitment Group Ltd' => 'FRCE Recruitment Group Ltd',
  'The Staff Room Agency Limited t/a The Staff Room' => 'The Staff Room Agency Limited',
  'Wise Employment (Swindon) Ltd t/a Pro Education' => 'Pro Education',
  'Your World Recruitment Limited' => 'Your World Education'
}

def remap_headers(row, header_map)
  r = row.map do |k, v|
    [header_map[k], v]
  end
  r.to_h
end

def add_supplier_id(row, suppliers)
  row.merge(supplier_id: suppliers[normalize_for_matching(row[:supplier_name])])
end

def normalize_for_matching(name)
  name
    .downcase
    .gsub('limited', '')
    .gsub('ltd', '')
    .strip
    .gsub(/\s+/, '-')
end

def subhead?(row)
  row[:number] =~ /Category Line/ || row[:number].nil?
end

def add_headings(row)
  %i[number supplier_name role job_type fee1 fee2 fee3].zip(row).to_h
end

def add_mv_headings(row)
  %i[number supplier_name role job_type lot1_fee1 lot1_fee2 lot1_fee3 blank lot2_fee1 lot2_fee2 lot2_fee3].zip(row).to_h
end

def missing_supplier_id?(row)
  row[:supplier_id].nil?
end

def remap_names(row, map)
  mapped = map.fetch(row[:supplier_name], row[:supplier_name])
  row.merge(supplier_name: mapped, original_name: row[:supplier_name].strip)
end

def strip_fields(row)
  row.map { |k, v| [k, v.is_a?(String) ? v.strip : v] }.to_h
end

def strip_keys_with_null_or_empty_values(row)
  row.reject { |_, v| v.nil? || v == '' }.to_h
end

def original_name_only(row)
  row.select { |k, _v| %i[supplier_id original_name].include? k }
end

branch_sheet = branch_workbook.sheet(0)

supplier_names = branch_sheet.parse(header_search: ['Supplier Name'])
                             .map { |row| remap_headers(row, header_map) }
                             .map { |row| strip_fields(row) }
                             .map { |row| row[:supplier_name] }.uniq

supplier_names += extra_supplier_names

supplier_csv = supplier_names.map { |name| [name, SecureRandom.uuid] }.to_h

suppliers_for_matching = supplier_csv.map { |k, v| [normalize_for_matching(k), v] } .to_h

mark_up_sheet = price_workbook.sheet(0)
pricing_names = mark_up_sheet
                .map            { |row| add_headings(row) }
                .map.with_index { |row, index| row.merge(line_no: index + 1) }
                .reject         { |row| subhead?(row) }
                .map            { |row| remap_names(row, name_map) }
                .map            { |row| add_supplier_id(row, suppliers_for_matching) }
                .map            { |row| original_name_only(row) }
                .uniq

mv_mark_up_sheet = mv_price_workbook.sheet(0)
mv_pricing_names = mv_mark_up_sheet
                   .map            { |row| add_mv_headings(row) }
                   .map.with_index { |row, index| row.merge(line_no: index + 1) }
                   .reject         { |row| subhead?(row) }
                   .map            { |row| remap_names(row, name_map) }
                   .map            { |row| add_supplier_id(row, suppliers_for_matching) }
                   .map            { |row| original_name_only(row) }
                   .uniq

nv_pricing_data = [
  {
    supplier_name: 'GRI UK',
    job_type: :nominated,
    fee: 0.04
  },
  {
    supplier_name: 'GRI UK',
    job_type: :daily_fee,
    fee: 2.50
  }
]

nv_pricing_names = nv_pricing_data
                   .map { |row| remap_names(row, name_map) }
                   .map { |row| add_supplier_id(row, suppliers_for_matching) }
                   .map { |row| original_name_only(row) }
                   .uniq

lot_1_accreditation_sheet = accredited_suppliers_workbook.sheet(0)
lot_1_accreditation_names =
  lot_1_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])
                           .map            { |row| remap_headers(row, header_map) }
                           .map.with_index { |row, index| row.merge(line_no: index + 1) }
                           .reject         { |row| row[:supplier_name].nil? || row[:supplier_name] == '' }
                           .map            { |row| remap_names(row, name_map) }
                           .map            { |row| strip_fields(row) }
                           .map            { |row| add_supplier_id(row, suppliers_for_matching) }
                           .map            { |row| original_name_only(row) }

lot_2_accreditation_sheet = accredited_suppliers_workbook.sheet(2)
lot_2_accreditation_names =
  lot_2_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])
                           .map            { |row| remap_headers(row, header_map) }
                           .map.with_index { |row, index| row.merge(line_no: index + 1) }
                           .reject         { |row| row[:supplier_name].nil? || row[:supplier_name] == '' }
                           .map            { |row| remap_names(row, name_map) }
                           .map            { |row| strip_fields(row) }
                           .map            { |row| add_supplier_id(row, suppliers_for_matching) }
                           .map            { |row| original_name_only(row) }

lot_3_accreditation_sheet = accredited_suppliers_workbook.sheet(3)
lot_3_accreditation_names =
  lot_3_accreditation_sheet.parse(header_search: ['Supplier Name'])
                           .map            { |row| remap_headers(row, header_map) }
                           .map.with_index { |row, index| row.merge(line_no: index + 1) }
                           .reject         { |row| row[:supplier_name].nil? || row[:supplier_name] == '' }
                           .map            { |row| remap_names(row, name_map) }
                           .map            { |row| strip_fields(row) }
                           .map            { |row| add_supplier_id(row, suppliers_for_matching) }
                           .map            { |row| original_name_only(row) }

accreditation_names = (lot_1_accreditation_names + lot_2_accreditation_names + lot_3_accreditation_names).uniq
vendor_pricing_names = (mv_pricing_names + nv_pricing_names)
supplier_names = supplier_csv.map { |name, id| { supplier_id: id, original_name: name } }

csv_template = {
  branches: supplier_names,
  pricing: pricing_names,
  vendor_pricing: vendor_pricing_names,
  accreditation: accreditation_names
}

csv = {}
csv_template.each do |column, names|
  names.each do |name|
    supplier_id = name[:supplier_id]
    if supplier_id
      name = name[:original_name]
      csv[supplier_id] ||= {}
      csv[supplier_id][column] = name
    else
      warn "No supplier id for #{name} in #{column} sheet."
    end
  end
end

csv_rows = csv.map do |id, columns|
  [id, columns[:branches], columns[:pricing], columns[:vendor_pricing], columns[:accreditation]].map { |a| a || '' }
end.sort_by { |x| x[1] }

csv_string = CSV.generate do |out|
  out << ['supplier_id', 'branches supplier name', 'pricing supplier name', 'vendor supplier name', 'accreditation supplier name']
  csv_rows.each do |row|
    out << row
  end
end

# rubocop:disable Rails/Output
puts csv_string
# rubocop:enable Rails/Output

