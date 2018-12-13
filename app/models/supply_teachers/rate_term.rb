module SupplyTeachers
  class RateTerm
    include StaticRecord

    attr_accessor :code, :description

    def self.[](code)
      find_by(code: code).description
    end
  end

  RateTerm.load_csv('supply_teachers/rate_terms.csv')
end
