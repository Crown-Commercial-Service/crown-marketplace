#!/usr/bin/env ruby
require 'bundler/setup'
require 'json'
require 'jsonpath'

json = ARGF.read
hash =
  JsonPath
  .for(json)
  .delete('..line_no')
  .to_hash
# rubocop:disable Rails/Output
puts JSON.pretty_generate(hash)
# rubocop:enable Rails/Output
