require 'bundler/setup'
require 'json'
require 'csv'

suppliers = JSON.parse(File.read(ARGV[0]))
suppliers = suppliers.sort_by { |s| s['supplier_name'] }
suppliers = suppliers.map do |supplier|
  sorted_keys = supplier.keys.sort
  supplier = sorted_keys.each_with_object({}) do |key, s|
    s[key] = supplier[key]
  end
  if supplier['branches']
    supplier['branches'] = supplier['branches'].sort_by { |b| b['line_no'] } if supplier['branches']
  end
  if supplier['pricing']
    supplier['pricing'] = supplier['pricing'].sort_by { |p| [ p['line_no'], p['job_type'] ]} if supplier['pricing']
  end
  supplier.delete('supplier_id')
  supplier.delete('line_no')
  supplier
end

puts JSON.pretty_generate(suppliers)
