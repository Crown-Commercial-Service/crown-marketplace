#!/usr/bin/env ruby

require 'json'
require 'uk_postcode'
require 'geocoder'
require 'yaml'
require 'pathname'
require './lib/tasks/supply_teachers/scripts/helpers/accredited_suppliers.rb'

suppliers = JSON.parse($stdin.read)

root_path = Pathname.new(__dir__).join('..')
geocoder_cache = {}
geocoder_cache_path = root_path.join('.geocoder-cache.yml')

if File.exist?(geocoder_cache_path)
  File.open(geocoder_cache_path) do |file|
    geocoder_cache = YAML.safe_load(file.read)
  end
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
# rubocop:disable Rails/Output
puts JSON.pretty_generate(suppliers)
# rubocop:enable Rails/Output
File.open(geocoder_cache_path, 'w') do |file|
  file.write(YAML.dump(geocoder_cache))
end
