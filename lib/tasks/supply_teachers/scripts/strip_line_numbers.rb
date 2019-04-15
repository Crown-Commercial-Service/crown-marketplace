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
puts JSON.pretty_generate(hash)
