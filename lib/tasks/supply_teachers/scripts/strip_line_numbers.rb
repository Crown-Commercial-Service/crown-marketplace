#!/usr/bin/env ruby
require 'bundler/setup'
require 'json'
require 'jsonpath'

def strip_line_numbers
  json = File.read('./storage/supply_teachers/current_data/output/data_with_line_numbers.json.tmp')
  hash =
    JsonPath
    .for(json)
    .delete('..line_no')
    .to_hash

  File.open('./storage/supply_teachers/current_data/output/data.json.tmp', 'w') do |f|
    f.puts JSON.pretty_generate(hash)
  end
end
