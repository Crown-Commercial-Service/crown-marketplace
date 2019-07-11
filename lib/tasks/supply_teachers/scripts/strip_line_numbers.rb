#!/usr/bin/env ruby
require 'bundler/setup'
require 'json'
require 'jsonpath'

def strip_line_numbers
  json = File.read(get_output_file_path('data_with_line_numbers.json'))
  hash =
    JsonPath
    .for(json)
    .delete('..line_no')
    .to_hash

  File.open(get_output_file_path('data.json'), 'w') do |f|
    f.puts JSON.pretty_generate(hash)
  end
end
