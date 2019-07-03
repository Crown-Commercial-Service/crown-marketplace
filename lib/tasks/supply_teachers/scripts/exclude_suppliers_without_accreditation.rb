#!/usr/bin/env ruby

require 'json'

def exclude_suppliers_without_accreditation
  suppliers = JSON.parse(File.read(get_output_file_path('data_merged.json')))
  suppliers_with_accreditation = suppliers.select { |s| s['accreditation'] }

  File.open(get_output_file_path('data_only_accredited.json'), 'w') do |f|
    f.puts JSON.pretty_generate(suppliers_with_accreditation)
  end
end
