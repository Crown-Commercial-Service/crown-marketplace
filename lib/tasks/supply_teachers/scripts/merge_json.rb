#!/usr/bin/env ruby

require 'bundler/setup'
require 'json'
require 'csv'
require 'optparse'
require 'active_support'

merge_key = nil
alias_rows = []
supplier_name_key = nil
destination_key = nil

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} a.json b.json [options]"

  opts.on('-k', '--key KEY', 'Key to merge arrays') do |v|
    merge_key = v
  end

  opts.on('-a', '--aliases FILE', 'CSV file with aliases') do |f|
    alias_rows = CSV.parse(File.read(f), headers: :first_row)
  end

  opts.on('-s', '--source-name-key KEY', 'Which column in csv to take key from') do |v|
    supplier_name_key = v
  end

  opts.on('-d', '--dest-name-key KEY', 'Which column in csv to map key to') do |v|
    destination_key = v
  end
end.parse!

raise 'Key required' unless merge_key

aliases = Hash.new { |_, k| k }
alias_rows.each_with_object(aliases) do |row, hash|
  aliased_supplier_name = row[supplier_name_key]
  hash[aliased_supplier_name] = row[destination_key || 'supplier_name']
  hash
end

uuid_lookup = alias_rows.map { |row| [row[destination_key || 'supplier_name'], row['supplier_id']] }.to_h

primary, secondary = ARGV

augmentations = JSON.parse(File.read(secondary)).map do |item|
  secondary_key = item.delete(merge_key)
  [aliases[secondary_key], item]
end.to_h

merged = JSON.parse(File.read(primary)).map do |primary_item|
  primary_key = primary_item.fetch(merge_key)
  key = aliases[primary_key]

  if augmentations.key?(key)
    secondary_item = augmentations.delete(key)
    primary_item.deep_merge(secondary_item).merge(supplier_id: uuid_lookup[primary_key])
  else
    primary_item
  end
end

augmentations.each do |k, item|
  supplier_id = uuid_lookup[k]
  if supplier_id
    merged << item.merge(supplier_id: supplier_id, supplier_name: k)
  else
    warn "#{k}: does not appear in aliases file (input/supplier_lookup.csv). Make sure you include it in the column '#{supplier_name_key}'"
  end
end
# rubocop:disable Rails/Output
puts JSON.pretty_generate(merged)
# rubocop:enable Rails/Output
