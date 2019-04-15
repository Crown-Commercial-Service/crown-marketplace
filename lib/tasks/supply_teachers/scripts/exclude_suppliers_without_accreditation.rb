#!/usr/bin/env ruby

require 'json'

suppliers = JSON.parse($stdin.read)
suppliers_with_accreditation = suppliers.select { |s| s['accreditation'] }
# rubocop:disable Rails/Output
puts JSON.pretty_generate(suppliers_with_accreditation)
# rubocop:enable Rails/Output
