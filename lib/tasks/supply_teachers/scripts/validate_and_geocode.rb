#!/usr/bin/env ruby

require 'json'
require 'uk_postcode'
require 'geocoder'
require 'yaml'
require 'pathname'
require 'csv'
require 'roo'

def validate_and_geocode
  current_data = SupplyTeachers::Admin::CurrentData.first
  current_accredited_path = input_file_path(current_data.current_accredited_suppliers)
  accredited_suppliers_workbook = Roo::Spreadsheet.open(current_accredited_path, extension: :xlsx)
  suppliers = []
  supplier_lookup_path = input_file_path(current_data.supplier_lookup)
  csv = CSV.open(URI.open(supplier_lookup_path), headers: true)
  csv.each do |row|
    suppliers << row.to_h.transform_keys!(&:to_sym)
  end

  lot_1_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 1 - Preferred Supplier List')
  lot_1_accreditation =
    lot_1_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])

  lot_2_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 2 - Master Vendor MSP')
  lot_2_accreditation =
    lot_2_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])

  lot_3_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 3 - Neutral Vendor MSP')
  lot_3_accreditation =
    lot_3_accreditation_sheet.parse(header_search: ['Supplier Name'])

  accredited_suppliers_hashes = lot_1_accreditation + lot_2_accreditation + lot_3_accreditation
  accredited_supplier_names = accredited_suppliers_hashes.map(&:values).flatten

  @accredited_suppliers = suppliers.select do |supplier|
    accredited_supplier_names.include?(supplier[:'accreditation supplier name'])
  end
# rubocop:disable Style/PreferredHashMethods, Rails/Blank
  def supplier_accredited?(id)
    return false if id.nil? || id.empty?

    @accredited_suppliers.select { |supplier| supplier.has_value?(id) }.any?
  end
# rubocop:enable Style/PreferredHashMethods, Rails/Blank



  suppliers = JSON.parse(File.read(get_output_file_path('data_with_vendors.json')))
  geocoder_cache = {}
  geocoder_cache_path = (Rails.root.join('storage', 'supply_teachers', 'current_data', '.geocoder-cache.yml'))

  if File.exist?(geocoder_cache_path)
    File.open(geocoder_cache_path) do |file|
      geocoder_cache = YAML.safe_load(file.read)
    end
  else FileUtils.touch(geocoder_cache_path)
  end

  Geocoder.configure(
    lookup: :google,
    api_key: ENV['GOOGLE_GEOCODING_API_KEY'],
    units: :mi,
    distance: :spherical,
    cache: geocoder_cache
  )

  def geocode(postcode)
    Geocoder.coordinates(postcode, params: { region: 'uk' })
  end

  def add_error(branch, error)
    branch['errors'] ||= []
    branch['errors'] << error
  end

  def errors?(branch)
    branch['errors'] && !branch['errors'].empty?
  end

  def fix_telephone(row)
    telephone = row['telephone']
    if telephone.is_a?(String)
      row.merge('telephone' => telephone.gsub(/^#/, ''))
    elsif telephone.is_a?(Integer)
      row.merge('telephone' => "0#{telephone}")
    elsif telephone.is_a?(Float)
      row.merge('telephone' => "0#{telephone.to_i}")
    else
      add_error(row, "telephone is unexpected type: #{telephone.inspect}")
      row
    end
  end

  def normalize_postcode(row)
    postcode = UKPostcode.parse(row['postcode'])
    if postcode.valid?
      row.merge 'postcode' => postcode.to_s
    else
      add_error(row, "postcode not valid #{row['postcode']}")
      row
    end
  end

  def geocode_branch(row)
    lat, lon = geocode(row['postcode'])
    if lat && lon
      row.merge('lat' => lat, 'lon' => lon)
    else
      add_error(row, "Unable to geocode #{row['postcode']}")
      row
    end
  end

  def check_contacts(row)
    empty_contacts = !row['contacts'] || row['contacts'].empty?
    add_error(row, 'Missing/malformed contacts: amount of contact names and emails don’t match') if empty_contacts
    row
  end

  def add_empty_lists(supplier)
    supplier['branches'] ||= []
    supplier['pricing'] ||= []
    supplier['master_vendor_pricing'] ||= []
    supplier['neutral_vendor_pricing'] ||= []
  end

  suppliers = suppliers.map do |supplier|
    supplier.tap do |s|
      next unless s['branches']

      s['branches'] = s['branches']
                        .map { |b| check_contacts(b) }
                        .map { |b| fix_telephone(b) }
                        .map { |b| normalize_postcode(b) }
                        .map { |b| geocode_branch(b) }
      add_empty_lists(s)
    end
  end

  suppliers.map do |supplier|
    supplier.tap do |s|
      next unless s['branches']
      branch_errors, branches = s['branches'].partition { |b| errors?(b) }
      branch_errors.each do |branch|
        warn "#{supplier['supplier_name']} - #{branch['branch_name']}: #{branch['errors'].inspect}. Check the branch row in the file 'input/Geographical Data all suppliers.xlsx'" if supplier_accredited?(supplier['supplier_name'])
      end
      s['branches'] = branches
    end
  end

  suppliers = suppliers.sort_by { |s| s['supplier_name'] }
  File.open(get_output_file_path('data_with_line_numbers.json'), 'w') do |f|
    f.puts JSON.pretty_generate(suppliers)
  end
  File.open(geocoder_cache_path, 'w') do |file|
    file.write(YAML.dump(geocoder_cache))
  end
end