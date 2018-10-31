class Term
  include StaticRecord

  attr_accessor :code, :description, :rate_term
end

Term.define(
  ['code',    'description',         'rate_term'],
  ['0_1',     'Up to 1 week',        'one_week'],
  ['1_4',     '1 week to 4 weeks',   'twelve_weeks'],
  ['4_8',     '4 weeks to 8 weeks',  'twelve_weeks'],
  ['8_12',    '8 weeks to 12 weeks', 'twelve_weeks'],
  ['12_plus', 'Over 12 weeks',       'more_than_twelve_weeks']
)
