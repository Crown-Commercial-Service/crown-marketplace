#!/usr/bin/env ruby

require 'json'

def exclude_suppliers_without_accreditation
  suppliers = JSON.parse(File.read('./storage/supply_teachers/current_data/output/data_merged.json.tmp'))
  suppliers_with_accreditation = suppliers.select { |s| s['accreditation'] }

  File.open('./storage/supply_teachers/current_data/output/data_only_accredited.json.tmp', 'w') do |f|
    f.puts JSON.pretty_generate(suppliers_with_accreditation)
  end
end
