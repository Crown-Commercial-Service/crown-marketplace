class Term
  include ActiveModel::Model

  attr_accessor :code, :description, :rate_term

  def self.all
    @all ||= []
  end

  def self.find_by(arg)
    all.find { |term| arg.all? { |k, v| term.public_send(k) == v } }
  end
end

Term.all.replace [
  Term.new(
    code: '0_1',
    description: 'Up to 1 week',
    rate_term: 'one_week'
  ),
  Term.new(
    code: '1_4',
    description: '1 week to 4 weeks',
    rate_term: 'twelve_weeks'
  ),
  Term.new(
    code: '4_8',
    description: '4 weeks to 8 weeks',
    rate_term: 'twelve_weeks'
  ),
  Term.new(
    code: '8_12',
    description: '8 weeks to 12 weeks',
    rate_term: 'twelve_weeks'
  ),
  Term.new(
    code: '12_plus',
    description: 'Over 12 weeks',
    rate_term: 'more_than_twelve_weeks'
  )
]
