module SupplyTeachers
  class SchoolCategory
    include Virtus.model
    include StaticRecord

    attribute :id, String
    attribute :name, String
    attribute :non_profit, Axiom::Types::Boolean

    def non_profit?
      non_profit
    end
  end

  SchoolCategory.load_csv('supply_teachers/school_categories.csv')
end
