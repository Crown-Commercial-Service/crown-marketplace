#!/usr/bin/env ruby

require 'bundler/setup'
require 'json'
require 'csv'
require 'optparse'
require 'active_support'

def merge_json(supplier_name_key: , destination_key:, destination_file:, primary:, secondary:)
  alias_rows = []
  merge_key = 'supplier_name'
  supplier_lookup_path = input_file_path(SupplyTeachers::Admin::CurrentData.first.supplier_lookup)
  alias_rows = CSV.parse(URI.open(supplier_lookup_path), headers: :first_row)

  aliases = Hash.new { |_, k| k }
  alias_rows.each_with_object(aliases) do |row, hash|
    aliased_supplier_name = row[supplier_name_key]
    hash[aliased_supplier_name] = row[destination_key || 'supplier_name']
    hash
  end

  uuid_lookup = alias_rows.map { |row| [row[destination_key || 'supplier_name'], row['supplier_id']] }.to_h

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
      File.open(get_output_file_path('errors.out'), 'a') do |f|
        f.puts "#{k}: does not appear in aliases file (Supplier lookup). Make sure you include it in the column '#{supplier_name_key}'."
      end
    end
  end
  File.open(destination_file, 'w') do |f|
    f.puts JSON.pretty_generate(merged)
  end
end

