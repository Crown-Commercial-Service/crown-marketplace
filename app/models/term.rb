class Term
  include StaticRecord

  attr_accessor :code, :description, :rate_term
end

require 'csv'
Term.define(*CSV.read(Rails.root.join('data', 'terms.csv')))
