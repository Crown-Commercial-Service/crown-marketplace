module SupplyTeachers
  class Term
    include StaticRecord

    attr_accessor :code, :description, :rate_term
  end

  Term.load_csv('terms.csv')
end
